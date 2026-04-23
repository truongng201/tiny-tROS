# How I started this project

Well, even when i make this work, i still have no idea how it works =>>>

First, you have to read the wiki osdev, and understand certain concepts

- What is a kernel ?
- What is a bootloader ?
- What is a cross compiler ?
- What is a linker script ?
- What is a VGA text mode ?
- What is a serial port ?
- What is GRUB ?
- What is an ISO image ?
- What is QEMU ?

## And more ,,,

Then, just copy the code from that wiki ask AI to explain it to you, and have fun with it.
Just kidding well not really, I mean I don't actuaclly understand it either :D
Well just assume that you understand a little bit about computer architecture, assembly language, and C programming language

- The kernel (people talk about this a lot): the central core of the operating system, controlling everything like CPU, memory, and devices. You can think of it as the "brain" of the OS, managing resources and providing services to applications.

- The bootloader (for some one who have been a windows installer before you know like when you have your first computer and you plug in a usb drive with windows installer, and you have to press F12 to boot from it) is the first thing that runs when you turn on your computer. It initializes the hardware and loads the kernel into memory, then jumps to it to start the OS. This is the boot.asm file in the boot folder. To clearly understand each line of this assembly code, you can reread the wiki osdev. But it just sets up the stack, loads the kernel from the disk into memory, and jumps to it.

- The cross compiler is a tool that allows you to compile code for a different architecture than the one you are running on. In this case, we are compiling code for the i686 architecture (32-bit), but we are running on a 64-bit machine. So how to install it exactly is a bit tricky. Here I already ask the AI to write a script to install it for you:

```bash
# Install dependencies for building the cross compiler
sudo apt update
sudo apt install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo libisl-dev wget curl

# Create a place for sources and install output
mkdir -p $HOME/src/cross
mkdir -p $HOME/opt/cross
cd $HOME/src/cross

# Download and extract binutils
wget https://ftp.gnu.org/gnu/binutils/binutils-2.42.tar.xz
wget https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz

tar -xf binutils-2.42.tar.xz
tar -xf gcc-14.2.0.tar.xz

# Setup environment variables (keep this permantly in your .bashrc or .zshrc)
echo 'export PREFIX="$HOME/opt/cross"' >> ~/.bashrc
echo 'export TARGET=i686-elf' >> ~/.bashrc
echo 'export PATH="$PREFIX/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# build i686-elf-binutils (this process will take a while)
mkdir -p build-binutils
cd build-binutils

../binutils-2.42/configure \
  --target=$TARGET \
  --prefix="$PREFIX" \
  --with-sysroot \
  --disable-nls \
  --disable-werror

make -j"$(nproc)"
make install

# This give you the i686-elf-as and i686-elf-ld, which are the assembler 
# and linker for the boot code and kernel linking
# you can check it by running 
i686-elf-as --version
i686-elf-ld --version

# build i686-elf-gcc (this process will take a while too, maybe even longer than binutils and it will also take a lot of cpu 
# and memory resource, so make sure you have enough resource before running this)
cd $HOME/src/cross
mkdir -p build-gcc
cd build-gcc

../gcc-14.2.0/configure \
  --target=$TARGET \
  --prefix="$PREFIX" \
  --disable-nls \
  --enable-languages=c \
  --without-headers

make all-gcc -j"$(nproc)"
make all-target-libgcc -j"$(nproc)"
make install-gcc
make install-target-libgcc

# verify the installation
i686-elf-gcc --version
```

- The linker script is a file that tells the linker how to link the kernel. It specifies the memory layout of the kernel, where the code and data should be placed in memory, and how to resolve symbols. This is the linker.ld file in the root folder. You can read more about it in the wiki osdev.

- The VGA text mode is a way to display text on the screen using the VGA hardware. It allows you to write characters and change their colors. This is used in the kernel to display "Hello, World!" on the screen. Well, my current code have two output mode, one is the VGA text mode, and the other is the serial output mode. I first run it with a server that just print the output to the terminal no vga here, you cannot use the screen.c in this mode so I have to write a new serial.c to print the output to the serial port (terminal only using com1). Later on I have my own ubuntu desktop and I can run the kernel with vga mode, so I can use the screen.c to print the output to the screen. You can check both of the output in the README.md file. You can run `make run` to run the kernel in vga mode, and `make run-headless` to run the kernel in serial output mode.

- The serial port is a way to communicate with the computer using a serial interface. It allows you to send and receive data one bit at a time. This is used in the kernel to print "Hello, World!" to the terminal.

- GRUB is a bootloader that allows you to boot multiple operating systems on your computer. It is used in this project to create an ISO image that can be booted from a USB drive or a virtual machine. You need grub.cfg file to tell GRUB how to boot the kernel, and you need to create an ISO image with GRUB as the bootloader, and include the kernel binary in it.

- The ISO image is a file that contains the entire contents of a CD or DVD. It can be used to create a bootable USB drive or to run the kernel in a virtual machine. In this project, we create an ISO image that contains the kernel binary and the GRUB bootloader, so that we can boot it on any machine.

- QEMU is a virtual machine emulator that allows you to run the kernel on your computer without needing to install it on a physical machine. It emulates the hardware of a computer, allowing you to test and debug your kernel in a safe environment.

- The all process of building the kernel is as follows:
  1. Write the boot code in assembly (boot.asm) to load the kernel into memory and jump to it.
  2. Write the kernel code in C (kernel.c) to do something, in this case, just print "Hello, World!" to the screen or terminal.
  3. The kernel code will include the library code (lib) and driver code (drivers) to use the functions and drivers provided by the kernel.
  4. The drivers will include the screen driver (screen.c) to print to the screen, and the serial driver (serial.c) to print to the terminal.
  5. Use the cross compiler (i686-elf-gcc) to compile the kernel code into an object file (kernel.o).
  6. Use the assembler (i686-elf-as) to assemble the boot code into an object file (boot.o).
  7. Use the linker (i686-elf-ld) to link the boot and kernel object files into a single binary (kernel.bin) using the linker script (linker.ld).
  8. Create an ISO image with GRUB as the bootloader, and include the kernel binary in it.

## Just some note

- Well, I am not an expert in OS development, I just want to learn how to build a kernel and OS for fun. Lots of things I don't understand, just copy and paste the code from the wiki osdev and ask AI to explain it to you, and have fun with it. I mean, I don't even understand it myself, I just want to make it work first, then maybe later on I can understand it better. So don't worry if you don't understand it, just keep trying and have fun with it.
- Yeah, I know, there are too much concepts to understand, I don't understand neither, but just keep trying and have fun with it (or just copy and paste the code from the wiki osdev and ask AI to explain it to you).
