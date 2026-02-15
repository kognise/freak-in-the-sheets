n = 11
out = 0

terms = 0 1
terms_len = 2
i = 2

temp1 = 0
temp2 = 0

neg1 = -1
neg2 = -2
pos1 = 1

_start:
loop:
    lte temp1 i n
    jmp0 temp1 after_loop
    add temp1 i neg1
    add temp2 i neg2
    load temp1 terms temp1
    load temp2 terms temp2
    add temp1 temp1 temp2
    store terms terms_len temp1
    add terms_len terms_len pos1
    add i i pos1
    jmp loop
after_loop:
    load out terms n
    halt