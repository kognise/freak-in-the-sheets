from llvm_to_shasm.backend import emit_shasm, parse_llvm_ir


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
