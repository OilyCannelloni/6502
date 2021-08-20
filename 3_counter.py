"""
3. Counter
Counts from 1 to 255 and puts the value into PORT_B
"""

from rom_maker import make_rom

rom = bytearray([
    # set all pins in PORT_B output
    0xa9, 0xff,         # lda $0xff
    0x8d, 0x02, 0x60,   # sta 0x6002

    # load a '1' to PORT_B
    0xa9, 0x01,
    0x8d, 0x00, 0x60,

    # increment value under address of PORT_B, then loop forever
    0xee, 0x00, 0x60,   # inc $0x6000
    0x4c, 0x0a, 0x80    # jmp $0x800a
])

make_rom(rom)