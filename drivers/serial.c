#include <stdbool.h>
#include <stdint.h>
#include "lib/string.h"

#define COM1_PORT 0x3F8

static inline void outb(uint16_t port, uint8_t value)
{
	__asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}

static inline uint8_t inb(uint16_t port)
{
	uint8_t result;
	__asm__ volatile ("inb %1, %0" : "=a"(result) : "Nd"(port));
	return result;
}

void serial_initialize(void)
{
	outb(COM1_PORT + 1, 0x00);
	outb(COM1_PORT + 3, 0x80);
	outb(COM1_PORT + 0, 0x03);
	outb(COM1_PORT + 1, 0x00);
	outb(COM1_PORT + 3, 0x03);
	outb(COM1_PORT + 2, 0xC7);
	outb(COM1_PORT + 4, 0x0B);
}

static bool serial_can_transmit(void)
{
	return (inb(COM1_PORT + 5) & 0x20) != 0;
}

void serial_writechar(char c)
{
	while (!serial_can_transmit()) {
	}

	outb(COM1_PORT, (uint8_t)c);
}

void serial_writestring(const char* data)
{
	for (size_t i = 0; i < string_length(data); i++) {
		if (data[i] == '\n') {
			serial_writechar('\r');
		}
		serial_writechar(data[i]);
	}
}