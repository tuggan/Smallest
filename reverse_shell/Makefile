all: shell

shell: shell.o sys.o
	ld.lld -static -o shell shell.o sys.o --entry=_start -z noexecstack -T link.ld
	strip -R .comment -R .note -s shell

shell.o: shell.c
    # maybe add -ffunction-sections -fdata-sections?
	clang -nostdlib -ffreestanding -fno-builtin -fno-stack-protector \
		-fomit-frame-pointer -Os -c shell.c -o shell.o


sys.o: sys.s
	nasm -f elf64 sys.s -o sys.o

clean:
	rm -f shell shell.o sys.o
