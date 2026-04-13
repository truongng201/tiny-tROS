#if !defined(screen_h)
#define screen_h

#include <stddef.h>
#include <stdint.h>

void screen_initialize(void);
void screen_setcolor(uint8_t color);
void screen_putentryat(char c, uint8_t color, size_t x, size_t y);
void screen_putchar(char c);
void screen_write(const char* data, size_t size);
void screen_writestring(const char* data);

#endif // screen_h