#include <stdio.h>

int strlen(const char* str) {
    uint32_t len = 0;
    while (str[len] != '\0') {
        len++;
    }
    return len;
}

void puts(const char* s) {
    for (int i = 0; i < strlen(s); i++) {
        VGA[i * 2] = s[i];
        VGA[i * 2 + 1] = 0x0f;
    }
}
