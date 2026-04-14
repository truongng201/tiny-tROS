#include "kernel.h"

#include "drivers/serial.h"
#include "drivers/screen.h"

void kernel_main() {
    serial_initialize();
    serial_writestring("[serial] kernel_main entered\n");

    screen_initialize();
    screen_writestring("Hello, World! Welcome to tiny-tROS kernel.\n");
    serial_writestring("Hello, World! Welcome to tiny-tROS kernel.\n");
}