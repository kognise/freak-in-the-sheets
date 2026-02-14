const_0 = 0
const_1 = 1
out = 0
entry_addr = entry
v_1 = 0
v_2 = 0
v_3 = 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
v_4 = 0
v_5 = 0
const_17 = 17
const_2 = 2
bb_8_addr = bb_8
v_9 = 0
v_10 = 0
v_11 = 0
bb_12_addr = bb_12
bb_27_addr = bb_27
v_13 = 0
v_14 = 0
v_16 = 0
v_17 = 0
v_18 = 0
v_20 = 0
v_21 = 0
v_22 = 0
bb_24_addr = bb_24
v_25 = 0
v_26 = 0
v_28 = 0
v_30 = 0
v_31 = 0
v_32 = 0
v_1_addr = v_1
v_2_addr = v_2
v_3_addr = v_3
v_4_addr = v_4
v_5_addr = v_5
_start:
    jmp entry_addr
entry:
    store v_1_addr const_0 const_0
    store v_2_addr const_0 const_17
    store v_3_addr const_0 const_0
    store v_3_addr const_1 const_1
    store v_4_addr const_0 const_2
    jmp bb_8_addr
bb_8:
    load v_9 v_4_addr const_0
    load v_10 v_2_addr const_0
    <= v_11 v_9 v_10
    jmp0 v_11 bb_27_addr
    jmp bb_12_addr
bb_12:
    load v_13 v_4_addr const_0
    sub v_14 v_13 const_1
    load v_16 v_3_addr v_14
    load v_17 v_4_addr const_0
    sub v_18 v_17 const_2
    load v_20 v_3_addr v_18
    add v_21 v_16 v_20
    load v_22 v_4_addr const_0
    store v_3_addr v_22 v_21
    jmp bb_24_addr
bb_24:
    load v_25 v_4_addr const_0
    add v_26 v_25 const_1
    store v_4_addr const_0 v_26
    jmp bb_8_addr
bb_27:
    load v_28 v_2_addr const_0
    load v_30 v_3_addr v_28
    store v_5_addr const_0 v_30
    load v_31 v_5_addr const_0
    add v_32 v_31 const_0
    add out v_32 const_0
    halt
