#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <path/to/file.c>"
    exit 1
fi

ASM_PATH=/Users/kognise/Downloads/liveshare
LLVM_PATH=/Users/kognise/Documents/Programming/github.com/llvm/llvm-project

echo "--- building llc"
cd $LLVM_PATH || exit
cmake --build build --target llc
cd $ASM_PATH || exit

echo "--- compiling c to llvm ir"
clang -S -emit-llvm -m32 -o ./code.ll "$1"

echo "--- compiling llvm ir to asm"
$LLVM_PATH/build/bin/llc -mtriple=fits ./code.ll || exit

echo "--- compiling asm to sheets"
bun asm ./code.s ./out.sheet || exit

echo "--- emitted to out.sheet"