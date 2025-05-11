section .text
global socket
global connect
global dup2
global execve
global exit
global read
global write

; int dup2(int oldfd, int newfd)
dup2:
    mov rax, 33
    syscall
    ret

; int socket(int domain, int type, int protocol)
socket:
    mov rax, 41
    syscall
    ret

; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
connect:
    mov rax, 42
    syscall
    ret

; int execve(const char *filename, char *const argv[], char *const envp[])
execve:
    mov rax, 59
    syscall
    ret
