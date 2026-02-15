from __future__ import annotations

import argparse
import os
from pathlib import Path
import sys

from .compiler import assemble_shasm_to_sheet, default_assembler_path, run_pipeline


_OPCODE_NAMES = {
    0: "lte",
    1: "add",
    2: "load",
    3: "load_a",
    4: "store",
    5: "store_a",
    6: "jmp0",
    7: "jmp0_a",
    8: "jmp",
    9: "jmp_a",
    10: "halt",
    11: "sub",
    12: "mul",
    13: "and",
    14: "or",
    15: "xor",
    16: "shl",
    17: "lshr",
    18: "ashr",
}


def _display_path(path: Path) -> str:
    return os.path.relpath(path, Path.cwd())


def _print_vm_hints(celly: bool) -> None:
    src_dir = Path(__file__).resolve().parents[3] / "src"
    if celly:
        print(f"use {_display_path(src_dir / 'celly_vm.lua')}")
        return
    print(
        f"use {_display_path(src_dir / 'vm.lua')} and {_display_path(src_dir / 'preview.lua')}"
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="llvm-to-shasm",
        description="Compile C to LLVM IR and lower a minimal subset to shasm.",
    )
    parser.add_argument("c_file", type=Path, help="Path to C source file")
    parser.add_argument(
        "--ll-out",
        type=Path,
        default=None,
        help="LLVM output path (default: sibling .ll file)",
    )
    parser.add_argument(
        "--asm-out",
        type=Path,
        default=None,
        help="shasm output path (default: sibling .asm file)",
    )
    parser.add_argument(
        "--sheet-out",
        type=Path,
        default=None,
        help="Sheet output path (default: sibling .sheet file)",
    )
    parser.add_argument(
        "--assembler", type=Path, default=None, help="Assembler JS path"
    )
    parser.add_argument(
        "--celly",
        default=False,
        action=argparse.BooleanOptionalAction,
        help="Use plain-cell assembler mode (via src/celly_assembler.js)",
    )
    parser.add_argument("--bun-bin", default="bun", help="bun executable name/path")
    parser.add_argument(
        "--clang-bin", default="clang", help="clang executable name/path"
    )
    parser.add_argument(
        "--opt-level",
        default="O0",
        help="LLVM optimization level passed to clang (O0/O1/O2/O3/Os/Oz)",
    )
    parser.add_argument(
        "--emit-ll",
        default=True,
        action=argparse.BooleanOptionalAction,
        help="Emit LLVM IR file (.ll)",
    )
    parser.add_argument(
        "--emit-asm",
        default=True,
        action=argparse.BooleanOptionalAction,
        help="Emit shasm file (.asm)",
    )
    return parser


def _decode_sheet_cell(cell: str) -> list[int]:
    text = cell.strip()
    if text.startswith("[") and text.endswith("]"):
        text = text[1:-1]
    if len(text) % 3 != 0:
        raise ValueError("Encoded cell payload length must be divisible by 3")

    values: list[int] = []
    for i in range(0, len(text), 3):
        a = ord(text[i]) - 32
        b = ord(text[i + 1]) - 32
        c = ord(text[i + 2]) - 32
        if a < 0 or a > 0x7FFF or b < 0 or b > 0x7FFF or c < 0 or c > 0x3:
            raise ValueError("Encoded cell contains out-of-range characters")

        unsigned = (a << 17) | (b << 2) | c
        if unsigned >= (1 << 31):
            values.append(unsigned - (1 << 32))
        else:
            values.append(unsigned)
    return values


def _run_disassemble(argv: list[str]) -> None:
    parser = argparse.ArgumentParser(
        prog="llvm-to-shasm disassemble",
        description="Decode one encoded sheet cell into instruction values.",
    )
    parser.add_argument("cell", help="Encoded cell string like: [ !  \"! 5! 4#]")
    args = parser.parse_args(argv)

    values = _decode_sheet_cell(args.cell)
    if not values:
        print("decoded: []")
        return

    opcode = values[0]
    op_name = _OPCODE_NAMES.get(opcode, f"unknown({opcode})")
    payload = " ".join(str(v) for v in values[1:])

    print(f"decoded: {values}")
    print(f"instruction: {op_name}{(' ' + payload) if payload else ''}")


def main() -> None:
    if len(sys.argv) > 1 and sys.argv[1] == "disassemble":
        _run_disassemble(sys.argv[2:])
        return

    parser = build_parser()
    args = parser.parse_args()

    ll_path, asm_path = run_pipeline(
        c_path=args.c_file,
        ll_path=args.ll_out,
        asm_path=args.asm_out,
        emit_ll=args.emit_ll,
        emit_asm=args.emit_asm,
        clang_bin=args.clang_bin,
        opt_level=args.opt_level,
    )

    if ll_path is not None:
        print(f"LLVM IR: {_display_path(ll_path)}")
    if asm_path is not None:
        print(f"shasm: {_display_path(asm_path)}")
        _print_vm_hints(args.celly)
    sheet_out = args.sheet_out
    if sheet_out is None and asm_path is not None:
        sheet_out = asm_path.with_suffix(".sheet")

    if sheet_out is not None:
        if asm_path is None:
            raise ValueError("Cannot emit sheet without asm output. Use --emit-asm.")
        assembler = args.assembler
        if assembler is None:
            assembler = default_assembler_path(celly=args.celly)
        assemble_shasm_to_sheet(
            asm_path=asm_path,
            sheet_path=sheet_out,
            assembler_path=assembler,
            bun_bin=args.bun_bin,
        )
        print(f"sheet: {_display_path(sheet_out)}")
        # Make sure your VM extends to X cells down
        print(
            f"Make sure C1:ZZ100 extends to ZZ{sheet_out.read_text().count('\n') + 4} down"
        )


if __name__ == "__main__":
    main()
