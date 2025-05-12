# Reverse Shell

This project showcases my attempt at creating the smallest possible reverse
shell. Currently, the compiled binary weighs in at **272 bytes**.

The primary goal here was to achieve basic reverse shell functionality with the
leanest possible codebase, prioritizing binary size above all other considerations.

| Binary                 | Source Language | Size (bytes) |
| ---------------------- | --------------- | -----------: |
| hello.asm.x86_64.linux | Assembly        |          272 |
| hello.c.x86_64.linux   | C               |         4504 |

## Usage

To utilize this reverse shell, you'll need to modify the source file
to specify the target IP address and port for the connection.

## Generating the IP Address Constant

For your convenience, you can use the following Python command to convert a
standard IPv4 address into the hexadecimal format required by the `shell.c`
code:

```shell
python3 magic.py
Enter IP address (e.g. 127.0.0.1): 10.11.131.43
Enter port number (e.g. 4242): 6666

🧙 Assembly-compatible magic bytes:
Port (htons format):     0x1a0a
IP address (LE format):  0x2b830b0a
```

The magic numbers are `0x1a0a` and `0x2b830b0a`

### shell.c

**Steps:**

1.  **Edit `shell.c`**: Open the `shell.c` file in a text editor.
2.  **Locate Target Information**: Find the lines within the code where the
    target IP address and port are defined at the top of the file.
3.  **Modify Target**: Replace the placeholder IP address and port with the
    actual IP address and port of your listening server.

### shell.s

1.  **Edit `shell.s`**: Open the `shell.s` file in a text editor.
2.  **Locate the target lines**: The targets are inlined to save space. It is
    lines 58 and 59.
    ```
    mov word [rsp + 2], 0x9210      ; sin_port = __builtin_bswap16(4242) (0x1092)
    mov dword [rsp + 4], 0x0100007F ; sin_addr = 127.0.0.1 (0x7F000001)
    ```
3.  **Change** the magic values to the ones generated with the script.

## Build

To compile all the shells into executables, use the provided Makefile:

```Shell
make
```

You can also specify what shells you want

```shell
make shell.asm.x86_64.linux
make shell.c.x86_64.linux
```

## Important Security Considerations

- Use with Caution: This is a basic reverse shell intended solely for
  educational and experimental purposes. Using it in unauthorized environments
  is illegal and unethical.
- Lack of Security Features: This minimal implementation lacks any form of
  encryption, authentication, or advanced security measures. All network
  traffic is transmitted in plain text.
- Potential Instability: Due to its extreme focus on minimizing size, this
  shell might be less robust and more prone to errors compared to more
  comprehensive and feature-rich implementations.

## Further Exploration

My next steps for this project involve expanding its compatibility to other
architectures and operating systems. Specifically, I plan to attempt:

- 32 bit systems
- ARM and ARM64 architectures
- Windows operating system
- macOS operating system (It might already work but i haven't tested it)
