#include <stdint.h>

int main(void) {
    int32_t n = 17;
    int32_t terms[18];
    terms[0] = 0;
    terms[1] = 1;

    for (int32_t i = 2; i <= n; i++) {
        terms[i] = terms[i + -1] + terms[i + -2];
    }

    int32_t out = terms[n];
    return (int)out;
}
