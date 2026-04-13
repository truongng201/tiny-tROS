#include "kernel.h"

#include "drivers/screen.h"

void kernel_main() {
    screen_initialize();
    screen_writestring("Hello, World! Welcome to tiny-tROS kernel.\n");
}