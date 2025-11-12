#include <stdio.h>

void kernel_main();

void kernel_main() {
    cputs("kernel@labos", VGA_GREEN);
    cputs(":", VGA_WHITE);
    cputs("~", VGA_LIGHT_BLUE);
    cputs(" $", VGA_WHITE);

    return;
}
