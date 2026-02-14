from pathlib import Path
from shutil import which
import subprocess

import pytest

from llvm_to_shasm.compiler import run_pipeline


def _bun_bin() -> str | None:
    from_path = which("bun")
    if from_path:
        return from_path
    fallback = Path.home() / ".bun" / "bin" / "bun"
    if fallback.exists():
        return str(fallback)
    return None


@pytest.mark.skipif(which("clang") is None or _bun_bin() is None, reason="clang and bun are required")
def test_fib_pipeline_can_emit_sheet(tmp_path: Path) -> None:
    bun_bin = _bun_bin()
    assert bun_bin is not None
    repo_root = Path(__file__).resolve().parents[3]
    fixture = Path(__file__).parent / "fixtures" / "fib.c"
    ll_path = tmp_path / "fib.ll"
    asm_path = tmp_path / "fib.asm"
    sheet_path = tmp_path / "out.sheet"

    run_pipeline(c_path=fixture, ll_path=ll_path, asm_path=asm_path)

    subprocess.run(
        [bun_bin, str(repo_root / "src/assembler.js"), str(asm_path), str(sheet_path)],
        cwd=repo_root,
        check=True,
        capture_output=True,
        text=True,
    )

    assert sheet_path.exists()
    text = sheet_path.read_text().strip()
    assert text
