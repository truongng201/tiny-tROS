ASM = i686-elf-as
CC = i686-elf-gcc
LD = i686-elf-ld

ASMFLAGS = --32
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
	$(OBJS_DIR)/serial.o \
	$(OBJS_DIR)/screen.o \
	$(OBJS_DIR)/string.o

KERNEL = iso/boot/kernel.elf
ISO_IMAGE = $(OBJS_DIR)/tiny-tROS.iso

all: $(KERNEL)

$(OBJS_DIR):
	mkdir -p $(OBJS_DIR)

$(OBJS_DIR)/boot.o: $(BOOT_DIR)/boot.asm | $(OBJS_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJS_DIR)/kernel.o: $(KERNEL_DIR)/kernel.c | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJS_DIR)/screen.o: $(DRIVER_DIR)/screen.c $(DRIVER_DIR)/screen.h | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJS_DIR)/serial.o: $(DRIVER_DIR)/serial.c $(DRIVER_DIR)/serial.h | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJS_DIR)/string.o: $(LIB_DIR)/string.c $(LIB_DIR)/string.h | $(OBJS_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(KERNEL): $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o $@

clean:
	rm -f $(OBJS_DIR)/*.o iso/boot/kernel.elf
	rm -f $(ISO_IMAGE)

run: $(KERNEL)
	grub-mkrescue -o $(ISO_IMAGE) iso
	qemu-system-i386 -cdrom $(ISO_IMAGE)

run-headless: $(KERNEL)
	grub-mkrescue -o $(ISO_IMAGE) iso
	qemu-system-i386 -cdrom $(ISO_IMAGE) -nographic

.PHONY: all run run-headless clean