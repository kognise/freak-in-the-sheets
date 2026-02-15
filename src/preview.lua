=LET(
    x, NOW(),
    cell, C1,
    
    a_data, MID(cell, 2, 1),
    b_data, MID(cell, 3, 1),
    c_data, MID(cell, 4, 1),
    a, IF(a_data = "", 0, CODE(a_data) - 32),
    b, IF(b_data = "", 0, CODE(b_data) - 32),
    c, IF(c_data = "", 0, CODE(c_data) - 32),
    
    combined, BITOR(
        BITOR(
            BITLSHIFT(BITAND(a, 32767), 17), 
            BITLSHIFT(BITAND(b, 32767), 2)
        ),
        BITAND(c, 3)
    ),
    IF(combined >= 2^31, combined - 2^32, combined)
)