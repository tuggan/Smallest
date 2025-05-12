# Hello World

This project showcases my attempt at creating the smallest possible hello world.
Currently, the smallest compiled binary (assembly) weighs in at **173 bytes**.

The primary goal here was to achieve an output to the shell of hello world in
the smallest possible binary size.

| Binary                 | Source Language | Size (bytes) |
| ---------------------- | --------------- | -----------: |
| hello.asm.x86_64.linux | Assembly        |          173 |
| hello.c.x86_64.linux   | C               |         1184 |

## Usage

No special instructions. Just build and run

## Build

Use the provided Makefile to build the project:

```Shell
make
```

Ensure that you have gcc and nasm available or edit the makefile to match your
system.

### Specific versions

You can build only the files you are intressted in:

```Shell
make hello.asm.x86_64.linux
make hello.c.x86_64.linux
```

## Further Exploration

My next steps for this project involve expanding its compatibility to other
architectures and operating systems. Specifically, I plan to attempt:

- ARM and ARM64 architectures
- Windows operating system
- macOS operating system (This should already work but I have yet to test it)
