# llvm-to-shasm

Small Python CLI that:

1. compiles a C file to LLVM IR (`.ll`)
2. parses a limited LLVM IR subset
3. emits shasm (`.asm`)

## Quick usage

From `src/llvm-to-shasm`:

`poetry run python -m llvm_to_shasm.cli tests/fixtures/fib.c`

This emits sibling files next to the input C file (for `fib.c`: `fib.ll` and `fib.asm`).

To also run the assembler and emit a sheet file:

`poetry run python -m llvm_to_shasm.cli tests/fixtures/fib.c --sheet-out tests/generated/out.sheet --bun-bin ${BUN_BIN:-bun}`

From repo root, full chain to `out.sheet`:

`bun run fib:c2sheet`

If Bun was just installed, open a new shell (or source your shell rc) so `bun` is on `PATH`.
