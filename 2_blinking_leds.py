"""
02 - Blinking leds
Attach 8 leds from PORT_B of 6522 adapter to ground through 330ohm resistance.
They should start blinking in a pattern:
01010101
10101010
repeated forever.
"""
from rom_maker import make_rom

rom = bytearray([
    0xa9, 0xff, # lda $0xff
    0x8d, 0x02, 0x60, # sta $6002

    0xa9, 0x55, # lda #$55
    0x8d, 0x00, 0x60,  # sta $6000

    0xa9, 0xaa, # lda #$aa
    0x8d, 0x00, 0x60,  # sta $6000

    0x4c, 0x05, 0x80    # jmp $8005
])

make_rom(rom)
