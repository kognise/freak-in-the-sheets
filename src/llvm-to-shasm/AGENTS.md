This project implements a compiler from a subset of C to a simple custom assembly language. Both are open to modifications in order to simplify the compiler design.

In particular, the subset of C should be restricted to the following:

- while/for/if statements
- no functions
- int64_t locals and globals
- arrays of int64_t (word addressing)
- no structs/unions, no floats, no varargs, no malloc, no function pointers

The assemby language is described below. Note that there is no explicit concept of registers - all operations are performed on memory addresses.

```
Parameters starting with & means they are memory addresses rather than the concret value.
The prefix * implies reading the value at the memory address (dereferencing).
Memory addresses are in the form of row[col] since memory is 2D.

Unless otherwise specified, the program counter (PC) increments after every instruction.

<= &out &a &b
    If *a <= *b, stores 1 at out[0], otherwise stores 0.

add &out &a &b
    Stores the result of adding *a + *b at out[0].

sub &out &a &b
    Stores the result of subtracting *a - *b at out[0].

load &out &row &col
    Read the value at (*row)[*col] and store it at out[0].
    Note that this reads the values at &row and &col and uses those values as the addresses.
    In the future it might be better for &row to be a concrete address instead of a reference.

store &row &col &in
    Store *in at (*row)[*col]. See load for further notes.

jmp0 &data &dest
    If *data == 0, sets the PC to *dest, otherwise increments it as usual.

jmp &dest
    Sets the PC to *dest.

halt
    Stops the PC from increasing, halting the program's execution.
```

Example program:

```
n = 17
result = 0
terms = 0 1
terms_len = 2
i = 2
i_lte_n = 0
prev1 = 0
prev2 = 0
neg1 = -1
neg2 = -2
pos1 = 1
loop_addr = loop
after_loop_addr = after_loop
terms_addr = terms
out = 0
_start:
loop:
    <= i_lte_n i n
    jmp0 i_lte_n after_loop_addr
    add prev1 i neg1
    add prev2 i neg2
    load prev1 terms_addr prev1
    load prev2 terms_addr prev2
    add result prev1 prev2
    store terms_addr terms_len result
    add terms_len terms_len pos1
    add i i pos1
    jmp loop_addr
after_loop:
    load out terms_addr n
    halt
```

Notes:

- you should install any necessary tools and libraries

Docs:

- https://llvm.org/docs/CodeGenerator.html
- https://llvm.org/docs/WritingAnLLVMBackend.html

Your goal is to have a compiler that can take the fib.c program and return the compiled assembly - make sure to actually run your code and verify the outputs.
