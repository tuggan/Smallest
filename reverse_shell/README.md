# Reverse shell

This is the smallest reverse shell I managed to create. As of writing this it
stands at 4504 bytes.

To use this file you have to edit shell.c and change the target address and port.


## Generate IP constant:
```shell
python3 -c "import socket, struct; ip='192.168.1.100'; print(hex(struct.unpack('<I', socket.inet_aton(ip))[0]))"
```
