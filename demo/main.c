int n = 10;

int _start() {
    int out[50];

    // Calculate the nth fibonacci number
    out[0] = 0;
    out[1] = 1;
    for (int i = 2; i <= n; i++) {
        out[i] = out[i - 1] + out[i - 2];
    }

    // Return it (calling convention places it in r0)
    return out[n];
}
