"""
1. No-op
The program does nothing.
After reset sequence, it reads the starting position (reset vector)
from positions 0xfffc and 0xfffd (little endian)
Then it does literaly nothing.
"""

rom = bytearray([0xea] * 32768)

rom[0x7ffc] = 0x00
rom[0x7ffd] = 0x80

with open("rom.bin", "wb") as rom_file:
    rom_file.write(rom)

