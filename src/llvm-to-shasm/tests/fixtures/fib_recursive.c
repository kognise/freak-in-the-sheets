#include <stdint.h>

int fib(int32_t n) {
    if (n <= 1) {
        return n;
    }
    return fib(n - 1) + fib(n - 2);
}

int main(void) {
    int32_t n = 5;
    return fib(n);
}
