#include "kernel.h"

#include "drivers/serial.h"
#include "drivers/screen.h"

void kernel_main() {
    screen_initialize();
    screen_writestring("Hello, tiny-tROS users! Welcome to the kernel world.\n");

    serial_initialize();
    serial_writestring("Hello, tiny-tROS users! Welcome to the kernel world with serial output mode.\n");
}