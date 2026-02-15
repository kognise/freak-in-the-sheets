*This repo contains about 10% of the work. For the other 90%, see our llvm & clang fork: https://github.com/KevinL10/llvm-project-treehacks/tree/fits*

# Freak in the Sheets

We wrote a compiler that can run any piece of software inside a spreadsheet.

```
clang --target=google-sheets main.c
```

## What???

LLVM is the world's most advanced compiler. It probably built the software you're using to read this. Under the hood, LLVM compiles a program using a "frontend" (converting C or Rust into an *intermediate representation*) and a "backend" (converting the intermediate representation into code that can be run on a specific computer).

We invented a novel instruction set, 2D memory architecture, and encoding system that is able to execute arbitrary code within the limitations of a spreadsheet. We then wrote an LLVM backend that is able to output directly to that ISA, enabling arbitrary code in **any programming language** to be run in Google Sheets.

The compiled source code is stored in memory alongside its data and executed in realtime.

![Pipeline](https://i.ibb.co/h1fHGYn8/Compilation-pipeline-1.png)

## How can you run arbitrary code in a spreadsheet?

A spreadsheet formula is a pure function of some input cells to some output cells. An abstract CPU can also be thought of as, for each clock tick, a pure function from the previous state of a memory tape to the resulting new state.

We abuse a Google Sheets feature called iterative calculation, designed to allow cells to contain self references to calculate higher precision values, to instead arbitrarily step forward our own virtual machine. Combining this with an unpatched backend validation exploit in Google Sheets, code can be run indefinitely without any user input (a key problem with some attempts at faking a CPU in a spreadsheet).

Once you have a functioning bytecode interpreter in Google Sheets, all that's left is defining the bounds of your new ISA, writing a simple two-pass assembler, and building an LLVM backend from scratch to target that ISA. (Hint: this was actually 80% of the work.)

## Challenges we ran into

This whole thing was insanely hard and we didn't know if we could get it to work at any point until the morning of submission. Google Sheets formulas are hard to wrestle with, LLVM is an insanely complex codebase, and the scope of our ambition was big.

One example of a fun challenge we faced was that of performance. Our programs were taking a very long time, and benchmarks revealed that the *more Google Sheets cells* the programs compiled to, the longer updates would take. So, we created a new method that can pack 16,666 32-bit integers into one horizontal cell instead of the previous 1, by taking advantage of Google Sheet's handling of Unicode (50,000 Unicode glyphs per cell, we can store 15 bits pet glyph, which gives us 3 glyphs per int and therefore 16,666 with exactly two chars left over for necessary surrounding brackets; we also have some extra room for pointer metadata and such if needed).

This is why there are so many Chinese characters when you execute your code. That's the memory!

![Diagram of speedup](https://i.ibb.co/JR74VGJz/Compilation-pipeline.png)
