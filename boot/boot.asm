global _start                  ; the entry symbol for ELF
extern kernel_main

; Multiboot v1 header for GRUB
MAGIC_NUMBER equ 0x1BADB002     ; define the magic number constant
FLAGS        equ 0x0            ; multiboot flags
CHECKSUM     equ -MAGIC_NUMBER  ; calculate the checksum
                                ; (magic number + checksum + flags should equal 0)

section .multiboot
align 4                         ; the header must be 4-byte aligned
    dd MAGIC_NUMBER             ; write the magic number to the machine code,
    dd FLAGS                    ; the flags,
    dd CHECKSUM                 ; and the checksum

section .text                   ; start of the text (code) section

_start:                        ; the loader label (defined as entry point in linker script)
    ; Set up a stack before entering C
    mov esp, stack_top
    ; Call C kernel entry
    call kernel_main

.hang:
    cli
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:
