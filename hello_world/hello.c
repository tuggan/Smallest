static const char str[] = "Hello world!\n";

inline long write(int fd, const void* buf, long count) {
    long ret;
    __asm__ volatile (
        "mov $1, %%rax\n\t"   // syscall number for write
        "syscall"
        : "=a"(ret)
        : "D"(fd), "S"(buf), "d"(count)
        : "rcx", "r11", "memory"
    );
    return ret;
}

inline void exit(int status) {
    __asm__ volatile (
        "mov $60, %%rax\n\t"  // syscall number for exit
        "syscall"
        :
        : "D"(status)
        : "rax", "rcx", "r11"
    );
    __builtin_unreachable();
}

void _start() {
    write(1, str, 13);
    exit(0);
}
