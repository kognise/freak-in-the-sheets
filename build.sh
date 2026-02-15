#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <path/to/file.c>"
    exit 1
fi

ASM_PATH=/Users/kognise/Downloads/liveshare
LLVM_PATH=/Users/kognise/Documents/Programming/github.com/llvm/llvm-project

echo "--- building clang"
cd $LLVM_PATH || exit
cmake --build build --target clang
cd $ASM_PATH || exit

echo "--- compiling c to asm"
$LLVM_PATH/build/bin/clang -S --target=fits -o code.s "$1" || exit

echo "--- compiling asm to sheets"
bun asm ./code.s ./out.sheet || exit
rm ./code.s

echo "--- emitted to out.sheet"