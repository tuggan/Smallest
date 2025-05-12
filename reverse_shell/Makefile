all: shell.c.x86_64.linux shell.asm.x86_64.linux

shell.c.x86_64.linux: shell.c.x86_64.linux.o sys.o
	ld -static -s -o shell.c.x86_64.linux shell.c.x86_64.linux.o sys.o --entry=_start -z noexecstack -T link.ld
	strip -R .comment -R .note -s shell.c.x86_64.linux

shell.c.x86_64.linux.o: shell.c
    # maybe add -ffunction-sections -fdata-sections?
	gcc -nostdlib -ffreestanding -fno-builtin -fno-stack-protector \
		-fomit-frame-pointer -Os -c shell.c -o shell.c.x86_64.linux.o

sys.o: sys.s
	nasm -f elf64 sys.s -o sys.o

shell.asm.x86_64.linux: shell.s
	nasm -f bin shell.s -o shell.asm.x86_64.linux
	chmod +x shell.asm.x86_64.linux

clean:
	rm -f shell.c.x86_64.linux shell.c.x86_64.linux.o sys.o shell.asm.x86_64.linux
