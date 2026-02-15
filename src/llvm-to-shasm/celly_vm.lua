=ARRAYFORMULA(IF(
    A1 = FALSE,
    Init!B:Z,
    IF(
        ISTEXT(C1),
        C1,
        LET(
            matrix, C1:E200,

            rewrite_col, LAMBDA(matrix, row, col, new_value,
                MAKEARRAY(
                    ROWS(matrix),
                    COLUMNS(matrix),
                    LAMBDA(r, c,
                        IF(AND(r = row + 2, c = col + 1),
                            new_value,
                            INDEX(matrix, r, c)
                        )
                    )
                )
            ),
            rewrite, LAMBDA(matrix, row, new_value, rewrite_col(matrix, row, 0, new_value)),
            deref_col, LAMBDA(row, col, INDEX(matrix, row + 2, col + 1)),
            deref, LAMBDA(row, deref_col(row, 0)),

            pc, deref(-1),
            pcm, rewrite(matrix, -1, pc + 1),
            arg, LAMBDA(i, deref_col(pc, i)),
            
            operation, arg(0),
            result, IF(operation = "lte",
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, IF(deref(a) <= deref(b), 1, 0),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "add",
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) + deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "sub",
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) - deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "mul",
                LET(
                    out, arg(1),
                    a, arg(2),
                    b, arg(3),
                    new_value, deref(a) * deref(b),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "load",
                LET(
                    out, arg(1),
                    row, arg(2),
                    col, arg(3),
                    new_value, deref_col(row, deref(col)),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "load_a",
                LET(
                    out, arg(1),
                    row, arg(2),
                    col, arg(3),
                    new_value, deref_col(deref(row), deref(col)),
                    rewrite(pcm, out, new_value)
                ),
            IF(operation = "store",
                LET(
                    row, arg(1),
                    col, arg(2),
                    in, arg(3),
                    rewrite_col(pcm, row, deref(col), deref(in))
                ),
            IF(operation = "store_a",
                LET(
                    row, arg(1),
                    col, arg(2),
                    in, arg(3),
                    rewrite_col(pcm, deref(row), deref(col), deref(in))
                ),
            IF(operation = "jmp0",
                LET(
                    data, arg(1),
                    dest, arg(2),
                    IF(deref(data) = 0, rewrite(matrix, -1, dest), pcm)
                ),
            IF(operation = "jmp0_a",
                LET(
                    data, arg(1),
                    dest, arg(2),
                    IF(deref(data) = 0, rewrite(matrix, -1, deref(dest)), pcm)
                ),
            IF(operation = "jmp",
                LET(
                    dest, arg(1),
                    rewrite(matrix, -1, dest)
                ),
            IF(operation = "jmp_a",
                LET(
                    dest, arg(1),
                    rewrite(matrix, -1, deref(dest))
                ),
            IF(operation = "halt", matrix,
            "ERROR at " & ADDRESS(pc + 2, 1) &
            ": unknown instruction [" & operation & "]"
            )))))))))),

            new_pc, INDEX(result, 1, 1),
            new_operation, INDEX(result, new_pc + 2, 1),
            rewrite_col(rewrite_col(result, -1, 2, new_operation), -1, 1, operation)
        )
    )
))
