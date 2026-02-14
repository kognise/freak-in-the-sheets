# llvm-to-shasm

Small Python CLI that:

1. compiles a C file to LLVM IR (`.ll`)
2. parses a limited LLVM IR subset
3. emits shasm (`.asm`)

## Quick usage

From `src/llvm-to-shasm`:

`poetry run llvm-to-shasm tests/fixtures/fib.c --ll-out tests/generated/fib.ll --asm-out tests/generated/fib.asm`

From repo root, full chain to `out.sheet`:

`bun run fib:c2sheet`

If Bun was just installed, open a new shell (or source your shell rc) so `bun` is on `PATH`.
