#include <stdio.h>

void kernel_main();

void kernel_main() {
    const char* msg = "Hello world from kernel!!!! :D";
    puts(msg);
    
    return;
}
