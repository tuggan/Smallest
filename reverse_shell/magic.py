import socket
import struct

def get_magic_bytes():
    ip_str = input("Enter IP address (e.g. 127.0.0.1): ").strip()
    port = int(input("Enter port number (e.g. 4242): ").strip())

    # Validate and convert
    try:
        ip_bytes = socket.inet_aton(ip_str)
    except socket.error:
        print("Invalid IP address.")
        return

    if not (0 < port < 65536):
        print("Invalid port number.")
        return

    port_be = struct.pack('<H', port)
    port_hex = f"{port_be.hex()}"

    ip_le = ip_bytes[::-1]
    ip_hex = f"{ip_le.hex()}"

    print("\n🪄 Magic bytes:")
    print(f"Port:        0x{port_hex}")
    print(f"IP address:  0x{ip_hex}")
    print("\n🧙 And the magic connect string for assembly:")
    print(f"0x{ip_hex}{port_hex}0002")

if __name__ == "__main__":
    get_magic_bytes()
