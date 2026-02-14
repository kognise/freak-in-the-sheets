from pathlib import Path
from shutil import which

import pytest

from llvm_to_shasm.compiler import run_pipeline


@pytest.mark.skipif(which("clang") is None, reason="clang is required")
def test_fib_pipeline_emits_ll_and_asm(tmp_path: Path) -> None:
    fixture = Path(__file__).parent / "fixtures" / "fib.c"
    ll_path = tmp_path / "fib.ll"
    asm_path = tmp_path / "fib.asm"

    emitted_ll, emitted_asm = run_pipeline(
        c_path=fixture,
        ll_path=ll_path,
        asm_path=asm_path,
    )

    assert emitted_ll == ll_path
    assert emitted_asm == asm_path
    assert ll_path.exists()
    assert asm_path.exists()

    asm = asm_path.read_text()
    assert "load" in asm
    assert "store" in asm
    assert "jmp" in asm
    assert "halt" in asm
