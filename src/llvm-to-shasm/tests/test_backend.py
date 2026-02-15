from llvm_to_shasm.backend import emit_shasm, parse_llvm_ir
import pytest


def test_parse_and_emit_minimal_flow() -> None:
    llvm = """
define i64 @main() {
entry:
  %a = alloca i64, align 8
  %b = alloca i64, align 8
  store i64 7, ptr %a, align 8
  %x = load i64, ptr %a, align 8
  %y = add nsw i64 %x, 3
  store i64 %y, ptr %b, align 8
  %z = load i64, ptr %b, align 8
  %ok = icmp sle i64 %z, 12
  br i1 %ok, label %then, label %else
then:
  ret i64 %z
else:
  ret i64 0
}
"""
    module = parse_llvm_ir(llvm)
    asm = emit_shasm(module)

    assert "add" in asm
    assert "load" in asm
    assert "store" in asm
    assert "jmp0" in asm
    assert "halt" in asm
    assert "_addr =" not in asm
    assert "v_a_addr" not in asm
    assert "    jmp entry" in asm


def test_parse_error_includes_source_location() -> None:
    llvm = """define i64 @main() {
entry:
  %a = alloca i64, align 8
  %bad = freeze i64 1
  ret i64 0
}
"""
    with pytest.raises(ValueError, match=r"/tmp/fail\.ll:4: Unsupported LLVM instruction"):
        parse_llvm_ir(llvm, source_name="/tmp/fail.ll")


def test_emits_for_i8_byte_gep_from_optimized_ir_shape() -> None:
    llvm = """define i32 @main() {
entry:
  %arr = alloca [2 x i32], align 4
  %p = getelementptr inbounds i8, ptr %arr, i64 4
  store i32 7, ptr %p, align 4
  %v = load i32, ptr %p, align 4
  ret i32 %v
}
"""
    module = parse_llvm_ir(llvm)
    asm = emit_shasm(module)

    assert "store" in asm
    assert "load" in asm
    assert "halt" in asm
