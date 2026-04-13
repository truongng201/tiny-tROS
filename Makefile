ASM = nasm
CC = gcc
LD = ld

ASMFLAGS = -f elf32
CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -nostdlib -Wall -Wextra -c
LDFLAGS = -m elf_i386 -T linker.ld

OBJS = boot.o kernel_entry.o kernel.o screen.o string.o

all: kernel.elf

boot.o: boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o boot.o

kernel_entry.o: kernel_entry.asm
	$(ASM) $(ASMFLAGS) kernel_entry.asm -o kernel_entry.o

kernel.o: kernel.c
	$(CC) $(CFLAGS) kernel.c -o kernel.o

screen.o: screen.c screen.h
	$(CC) $(CFLAGS) screen.c -o screen.o

string.o: string.c string.h
	$(CC) $(CFLAGS) string.c -o string.o

kernel.elf: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) $(OBJS) -o kernel.elf

clean:
	rm -f *.o *.elf

.PHONY: all clean