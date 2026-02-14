n = 50
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
    lte i_lte_n i n
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