CFLAGS = -s -Os -nostartfiles -nostdlib -static -Wl,--nmagic
ASFLAGS = -f bin

all: hello.c.x86_64.linux hello.asm.x86_64.linux

hello.c.x86_64.linux: hello.c
	cc $(CFLAGS) -o hello.c.x86_64.linux hello.c

hello.asm.x86_64.linux: hello.s
	nasm $(ASFLAGS) hello.s -o hello.asm.x86_64.linux
	chmod +x ./hello.asm.x86_64.linux

clean:
	rm -f hello.c.x86_64.linux hello.asm.x86_64.linux
