from __future__ import annotations

import subprocess
from pathlib import Path

from .backend import emit_shasm, parse_llvm_ir


def _normalize_opt_level(opt_level: str) -> str:
    level = opt_level.strip().upper()
    if level.startswith("-"):
        level = level[1:]
    if level not in {"O0", "O1", "O2", "O3", "OS", "OZ"}:
        raise ValueError(f"Unsupported optimization level: {opt_level}")
    return level


def compile_c_to_llvm(
    c_path: Path,
    ll_path: Path,
    clang_bin: str = "clang",
    opt_level: str = "O0",
) -> None:
    normalized_opt_level = _normalize_opt_level(opt_level)
    ll_path.parent.mkdir(parents=True, exist_ok=True)
    command = [
        clang_bin,
        "-S",
        "-emit-llvm",
        f"-{normalized_opt_level}",
    ]
    if normalized_opt_level == "O0":
        command.extend(["-Xclang", "-disable-O0-optnone"])
    command.extend([str(c_path), "-o", str(ll_path)])
    subprocess.run(
        command,
        check=True,
        capture_output=True,
        text=True,
    )


def compile_llvm_to_shasm(ll_path: Path, asm_path: Path) -> str:
    llvm_ir = ll_path.read_text()
    module = parse_llvm_ir(llvm_ir, source_name=str(ll_path))
    asm = emit_shasm(module)
    asm_path.parent.mkdir(parents=True, exist_ok=True)
    asm_path.write_text(asm)
    return asm


def assemble_shasm_to_sheet(
    asm_path: Path,
    sheet_path: Path,
    assembler_path: Path,
    bun_bin: str = "bun",
) -> None:
    sheet_path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [bun_bin, str(assembler_path), str(asm_path), str(sheet_path)],
        check=True,
        capture_output=True,
        text=True,
    )


def run_pipeline(
    c_path: Path,
    ll_path: Path | None = None,
    asm_path: Path | None = None,
    emit_ll: bool = True,
    emit_asm: bool = True,
    clang_bin: str = "clang",
    opt_level: str = "O0",
) -> tuple[Path | None, Path | None]:
    c_path = c_path.resolve()
    if ll_path is None:
        ll_path = c_path.with_suffix(".ll")
    if asm_path is None:
        asm_path = c_path.with_suffix(".asm")

    if emit_ll:
        compile_c_to_llvm(c_path, ll_path, clang_bin=clang_bin, opt_level=opt_level)
    if emit_asm:
        if not ll_path.exists():
            raise FileNotFoundError(f"LLVM IR file not found: {ll_path}")
        compile_llvm_to_shasm(ll_path, asm_path)

    return (ll_path if emit_ll else None, asm_path if emit_asm else None)
