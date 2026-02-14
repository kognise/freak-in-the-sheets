from __future__ import annotations

import argparse
from pathlib import Path

from .compiler import assemble_shasm_to_sheet, run_pipeline


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
    parser.add_argument("--sheet-out", type=Path, default=None, help="Optional sheet output path")
    parser.add_argument("--assembler", type=Path, default=None, help="Assembler JS path")
    parser.add_argument("--bun-bin", default="bun", help="bun executable name/path")
    parser.add_argument("--clang-bin", default="clang", help="clang executable name/path")
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


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    ll_path, asm_path = run_pipeline(
        c_path=args.c_file,
        ll_path=args.ll_out,
        asm_path=args.asm_out,
        emit_ll=args.emit_ll,
        emit_asm=args.emit_asm,
        clang_bin=args.clang_bin,
    )

    if ll_path is not None:
        print(f"LLVM IR: {ll_path}")
    if asm_path is not None:
        print(f"shasm: {asm_path}")
    if args.sheet_out is not None:
        if asm_path is None:
            raise ValueError("Cannot emit sheet without asm output. Use --emit-asm.")
        assembler = args.assembler
        if assembler is None:
            assembler = Path(__file__).resolve().parents[3] / "src" / "assembler.js"
        assemble_shasm_to_sheet(
            asm_path=asm_path,
            sheet_path=args.sheet_out,
            assembler_path=assembler,
            bun_bin=args.bun_bin,
        )
        print(f"sheet: {args.sheet_out}")


if __name__ == "__main__":
    main()
