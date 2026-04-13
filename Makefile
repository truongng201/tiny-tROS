ASM = nasm
CC = gcc
LD = ld

ASMFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -Wall -Wextra -c
LDFLAGS = -m elf_i386 -T linker.ld

BOOT_DIR = boot
KERNEL_DIR = kernel
DRIVER_DIR = drivers
LIB_DIR = lib

OBJS_DIR = bin

OBJS = $(OBJS_DIR)/boot.o $(OBJS_DIR)/kernel_entry.o $(OBJS_DIR)/kernel.o $(OBJS_DIR)/screen.o $(OBJS_DIR)/string.o

all: kernel.elf

boot.o: $(BOOT_DIR)/boot.asm
	$(ASM) $(ASMFLAGS) $< -o ${OBJS_DIR}/boot.o

kernel_entry.o: $(KERNEL_DIR)/kernel_entry.asm
	$(ASM) $(ASMFLAGS) $< -o ${OBJS_DIR}/kernel_entry.o

kernel.o: $(KERNEL_DIR)/kernel.c
	$(CC) $(CFLAGS) $< -o ${OBJS_DIR}/kernel.o

screen.o: $(DRIVER_DIR)/screen.c $(DRIVER_DIR)/screen.h
	$(CC) $(CFLAGS) $< -o ${OBJS_DIR}/screen.o

string.o: $(LIB_DIR)/string.c $(LIB_DIR)/string.h
	$(CC) $(CFLAGS) $< -o ${OBJS_DIR}/string.o

kernel.elf: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o kernel.elf

clean:
	rm -f ${OBJS_DIR}/*.o ${OBJS_DIR}/*.elf

.PHONY: all clean