# Reverse Shell

This project showcases my attempt at creating the smallest possible reverse
shell. Currently, the compiled binary weighs in at **4504 bytes**.

The primary goal here was to achieve basic reverse shell functionality with the
leanest possible codebase, prioritizing binary size above all other considerations.

## Usage

To utilize this reverse shell, you'll need to modify the `shell.c` source file
to specify the target IP address and port for the connection.

**Steps:**

1.  **Edit `shell.c`**: Open the `shell.c` file in a text editor.
2.  **Locate Target Information**: Find the lines within the code where the
    target IP address and port are defined.
3.  **Modify Target**: Replace the placeholder IP address and port with the
    actual IP address and port of your listening server.

## Generating the IP Address Constant

For your convenience, you can use the following Python command to convert a
standard IPv4 address into the hexadecimal format required by the `shell.c`
code:

```shell
python3 -c "import socket, struct; ip='YOUR_TARGET_IP'; print(hex(struct.unpack('<I', socket.inet_aton(ip))[0]))"
```

Remember to replace YOUR_TARGET_IP with the actual IP address of your listening
server. The output of this command should then be used to update the
corresponding value in shell.c.

## Build

To compile the shell.c file into an executable, use the provided Makefile:

```Shell
make
```

Ensure that you have clang and nasm available or edit the makefile to match your
system.

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

- ARM and ARM64 architectures
- Windows operating system
- macOS operating system
