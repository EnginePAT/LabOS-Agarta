#ifndef _STDIO_H
#define _STDIO_H

#include "stdint.h"

#define VGA ((char*)0xb8000)
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

int strlen(const char* str);
void putc(char c);
void puts(const char* s);

#endif      // _STDIO_H
