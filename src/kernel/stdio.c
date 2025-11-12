#include <stdio.h>

static uint32_t cursor_row = 0;
static uint32_t cursor_col = 0;
uint8_t cursor_x = 0;
uint8_t cursor_y = 0;

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

void cputs(const char* str, uint8_t color) {
    for (int i = 0; i < strlen(str); i++) {

        if (str[i] == '\n') {
            cursor_col = 0;
            cursor_row++;
        } else {
            VGA[(cursor_row * VGA_WIDTH + cursor_col) * 2] = str[i];
            VGA[(cursor_row * VGA_WIDTH + cursor_col) * 2 + 1] = color;
            cursor_col++;
        }

        if (cursor_col == VGA_WIDTH) {
            cursor_col = 0;
            cursor_row++;
        }
    }
}
