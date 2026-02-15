# llvm-to-shasm

Small Python CLI that:

1. compiles a C file to LLVM IR (`.ll`)
2. parses a limited LLVM IR subset
3. emits shasm (`.asm`)

## Quick usage

From `src/llvm-to-shasm`:

`poetry run python -m llvm_to_shasm.cli tests/fixtures/fib.c`

This emits sibling files next to the input C file (for `fib.c`: `fib.ll` and `fib.asm`).
By default, LLVM IR is emitted with `-O0`; pass `--opt-level O1` (or higher) to run LLVM optimization passes before IR emission.

To also run the assembler and emit a sheet file:

`poetry run python -m llvm_to_shasm.cli tests/fixtures/fib.c --sheet-out tests/generated/out.sheet --bun-bin ${BUN_BIN:-bun}`

To emit the plain-cell variant (celly mode), use:

`poetry run python -m llvm_to_shasm.cli tests/fixtures/fib.c --sheet-out tests/generated/out.sheet --celly --bun-bin ${BUN_BIN:-bun}`

The assembler and VM go hand in hand: the assembler produces sheet output that the VM executes.

From repo root, full chain to `out.sheet`:

`bun run fib:c2sheet`

If Bun was just installed, open a new shell (or source your shell rc) so `bun` is on `PATH`.
