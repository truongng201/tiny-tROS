ASM = nasm
CC = gcc
LD = ld

ASMFLAGS = -f elf32
CFLAGS = -I. -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -Wall -Wextra -c
LDFLAGS = -m elf_i386 -T linker.ld

BOOT_DIR = boot
KERNEL_DIR = kernel
DRIVER_DIR = drivers
LIB_DIR = lib
OBJS_DIR = bin

OBJS = \
	$(OBJS_DIR)/boot.o \
	$(OBJS_DIR)/kernel.o \
	$(OBJS_DIR)/screen.o \
	$(OBJS_DIR)/string.o

KERNEL = iso/boot/kernel.elf

all: $(KERNEL)

$(OBJS_DIR):
	mkdir -p $(OBJS_DIR)

$(OBJS_DIR)/boot.o: $(BOOT_DIR)/boot.asm | $(OBJS_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJS_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJS_DIR)/screen.o: $(DRIVER_DIR)/screen.c $(DRIVER_DIR)/screen.h | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJS_DIR)/string.o: $(LIB_DIR)/string.c $(LIB_DIR)/string.h | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@

clean:
	rm -f $(OBJS_DIR)/*.o iso/boot/kernel.elf
	rm -f iso/tiny-tROS.iso

run: $(KERNEL)
	grub-mkrescue -o iso/tiny-tROS.iso iso
	qemu-system-i386 -cdrom iso/tiny-tROS.iso -nographic

.PHONY: all run clean