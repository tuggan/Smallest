; hello.asm – minimal Linux x86-64 program
; Assemble with: nasm -f elf64 hello.asm
; Link with:     ld -o hello hello.o -nostdlib -static
BITS 64

org 0x400000 ; Default base address for 64-bit executables

ehdr:                         ; Elf64_Ehdr
    db 0x7F, "ELF"            ; e_ident: ELF magic
    db 2, 1, 1, 0             ; e_ident: 64 bit, little endian, version 1, target System V
    db 0, 0, 0, 0, 0, 0, 0, 0 ; e_ident: padding
    dw 2                      ; e_type
    dw 0x3E                   ; e_machine
    dd 1                      ; e_version
    dq _start                 ; e_entry
    dq phdr - $$              ; e_phoff
    dq 0                      ; e_shoff
    dd 0                      ; e_flags
    dw ehdr_size              ; e_ehsize
    dw phdr_size              ; e_phentsize
    dw 1                      ; e_phnum
    dw 0                      ; e_shentsize
    dw 0                      ; e_shnum
    dw 0                      ; e_shstrndx

ehdr_size equ $ - ehdr

phdr:            ; Elf64_Phdr
    dd 1         ; p_type
    dd 5         ; p_flags
    dq 0         ; p_offset
    dq $$        ; p_vaddr
    dq $$        ; p_paddr
    dq file_size ; p_filesz
    dq file_size ; p_memsz
    dq 0x1000    ; p_align

phdr_size equ $ - phdr

section .rodata
    msg: db "Hello world!", 0x0A
    len equ $ - msg

section .text
    global _start

_start:
    ; write(1, message, 12)
    mov     rax, 1          ; syscall: write
    mov     rdi, 1          ; fd: stdout
    mov     rsi, msg        ; buf
    mov     rdx, len        ; count
    syscall

    ; exit(0)
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status = 0
    syscall

file_size equ $ - $$
