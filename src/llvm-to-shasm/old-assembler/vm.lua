=ARRAYFORMULA(IF(
    A1 = FALSE,
    Init!B:Z,
    IF(
        REGEXMATCH(TO_TEXT(D1), "^ERROR: "),
        D1,
        LET(
            matrix, C1:E100,

            rewrite_col, LAMBDA(matrix, row, col, new_value, LET(
                real_col, FLOOR(col / 16666),
                byte_start, MOD(col, 16666) * 3 + 1,
                unsigned_val, IF(new_value < 0, new_value + 2^32, new_value),

                a, BITAND(BITRSHIFT(unsigned_val, 17), 32767),
                b, BITAND(BITRSHIFT(unsigned_val, 2), 32767),
                c, BITAND(unsigned_val, 3),
                encoded_chunk, CHAR(a + 32) & CHAR(b + 32) & CHAR(c + 32),

                MAKEARRAY(
                    ROWS(matrix),
                    COLUMNS(matrix),
                    LAMBDA(r, c,
                        IF(AND(r = row + 2, c = real_col + 1),
                            LET(
                                current_str, INDEX(matrix, r, c),
                                current_len, LEN(current_str),
                                padded_str, IF(current_len < byte_start, 
                                            current_str & REPT(CHAR(32), byte_start - current_len), 
                                            current_str),
                                REPLACE(padded_str, byte_start + 1, 3, encoded_chunk)
                            ),
                            INDEX(matrix, r, c)
                        )
                    )
                )
            )),
            deref_internal_col, LAMBDA(matrix, row, col, LET(
                real_col, FLOOR(col / 16666),
                byte_start, MOD(col, 16666) * 3 + 1,
                cell, INDEX(matrix, row + 2, real_col + 1),
                
                a_data, MID(cell, byte_start + 1, 1),
                b_data, MID(cell, byte_start + 2, 1),
                c_data, MID(cell, byte_start + 3, 1),
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
            )),
            
            rewrite, LAMBDA(matrix, row, new_value, rewrite_col(matrix, row, 0, new_value)),
            deref_col, LAMBDA(row, col, deref_internal_col(matrix, row, col)),
            deref, LAMBDA(row, deref_col(row, 0)),

            pc, deref(-1),
            pcm, rewrite(matrix, -1, pc + 1),
            arg, LAMBDA(i, deref_col(pc, i)),
            operation, arg(0),

            op_lte,     0,
            op_add,     1,
            op_sub,     11,
            op_mul,     12,
            op_set,     13,
            op_load,    2,
            op_load_a,  3,
            op_store,   4,
            op_store_a, 5,
            op_jmp0,    6,
            op_jmp0_a,  7,
            op_jmp,     8,
            op_jmp_a,   9,
            op_halt,    10,
            
            IF(operation = op_lte,
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, IF(deref(a) <= deref(b), 1, 0),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_add,
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) + deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_sub,
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) - deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_mul,
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) * deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_load,
                LET(
                    out, arg(1),
                    row, arg(2),
                    col, arg(3),
                    new_value, deref_col(row, deref(col)),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_load_a,
                LET(
                    out, arg(1),
                    row, arg(2),
                    col, arg(3),
                    new_value, deref_col(deref(row), deref(col)),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = op_store,
                LET(
                    row, arg(1),
                    col, arg(2),
                    in, arg(3),
                    rewrite_col(pcm, row, deref(col), deref(in))
                ),
            IF(operation = op_store_a,
                LET(
                    row, arg(1),
                    col, arg(2),
                    in, arg(3),
                    rewrite_col(pcm, deref(row), deref(col), deref(in))
                ),
            IF(operation = op_jmp0,
                LET(
                    data, arg(1),
                    dest, arg(2),
                    IF(deref(data) = 0, rewrite(matrix, -1, dest), pcm)
                ),
            IF(operation = op_jmp0_a,
                LET(
                    data, arg(1),
                    dest, arg(2),
                    IF(deref(data) = 0, rewrite(matrix, -1, deref(dest)), pcm)
                ),
            IF(operation = op_jmp,
                LET(
                    dest, arg(1),
                    rewrite(matrix, -1, dest)
                ),
            IF(operation = op_jmp_a,
                LET(
                    dest, arg(1),
                    rewrite(matrix, -1, deref(dest))
                ),
            IF(operation = op_set,
                LET(
                    dest, arg(1),
                    data, arg(2),
                    rewrite(pcm, dest, data)
                ),
            IF(operation = op_halt, matrix,
            "ERROR: unknown instruction [" & operation & "]"
            ))))))))))))))
        )
    )
))
