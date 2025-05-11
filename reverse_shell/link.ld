ENTRY(_start)              # Entry point symbol

SECTIONS {
    . = 0x401000;          # Start address for loading

    .text : ALIGN(4K) {    # Align to page boundary (optional)
        *(.text.start)     # Your _start() function
        *(.text*)          # All other code
        *(.rodata*)        # Read-only data like strings, constants
        *(.data*)          # Writable data (minimize this if possible)
        *(.bss*)           # Uninitialized data (size only, not in file)
    } :text                # Assign all to 'text' segment

    /DISCARD/ : {
        *(.bss*)
        *(.data*)
        *(.rodata*)
        *(.comment*)       # Compiler info strings
        *(.note*)          # Note sections (e.g. build IDs)
        *(.eh_frame*)      # Exception handling info
        *(.debug*)         # Debug info
    }
}

PHDRS {
  text PT_LOAD FLAGS(5);   # R + X (no writable segment)
}
