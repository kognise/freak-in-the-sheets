from __future__ import annotations

import subprocess
from pathlib import Path

from .backend import emit_shasm, parse_llvm_ir


def compile_c_to_llvm(c_path: Path, ll_path: Path, clang_bin: str = "clang") -> None:
    ll_path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            clang_bin,
            "-S",
            "-emit-llvm",
            "-O0",
            "-Xclang",
            "-disable-O0-optnone",
            str(c_path),
            "-o",
            str(ll_path),
        ],
        check=True,
        capture_output=True,
        text=True,
    )


def compile_llvm_to_shasm(ll_path: Path, asm_path: Path) -> str:
    llvm_ir = ll_path.read_text()
    module = parse_llvm_ir(llvm_ir)
    asm = emit_shasm(module)
    asm_path.parent.mkdir(parents=True, exist_ok=True)
    asm_path.write_text(asm)
    return asm


def run_pipeline(
    c_path: Path,
    ll_path: Path | None = None,
    asm_path: Path | None = None,
    emit_ll: bool = True,
    emit_asm: bool = True,
    clang_bin: str = "clang",
) -> tuple[Path | None, Path | None]:
    c_path = c_path.resolve()
    if ll_path is None:
        ll_path = c_path.with_suffix(".ll")
    if asm_path is None:
        asm_path = c_path.with_suffix(".asm")

    if emit_ll:
        compile_c_to_llvm(c_path, ll_path, clang_bin=clang_bin)
    if emit_asm:
        if not ll_path.exists():
            raise FileNotFoundError(f"LLVM IR file not found: {ll_path}")
        compile_llvm_to_shasm(ll_path, asm_path)

    return (ll_path if emit_ll else None, asm_path if emit_asm else None)
