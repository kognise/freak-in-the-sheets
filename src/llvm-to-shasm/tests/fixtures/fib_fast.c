#include <stdint.h>

int main(void) {
    int32_t n = 17;
    int32_t prev1 = 0;
    int32_t prev2 = 1;
    int32_t out = 0;
    int32_t i = 2;

    while (i <= n) {
        out = prev1 + prev2;
        prev1 = prev2;
        prev2 = out;
        i++;
    }

    return (int)out;
}
