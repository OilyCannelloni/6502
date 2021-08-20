"""
4. Fibonacci
Calculates the first few terms of fibonacci sequence
and puts them into PORT_B.
Upon exceeding 255 starts over
"""

from rom_maker import make_rom

rom = bytearray([
    # set all pins of PORT_B to outputs 
    0xa9, 0xff,         # lda $0xff
    0x8d, 0x02, 0x60,   # sta 0x6002

    # initialize register X to 0 and register A to 1.
    # set PORT_B to 0
    0xa2, 0x00,         # ldx 0x00
    0xa9, 0x01,         # lda 0x01
    0x8e, 0x00, 0x60,   # stx 0x6000
    
    # calculate next fibonacci term
    # temporarily store contents of the A register in X
    # add the displayed value to A
    # display the old value of A
    0xaa,               # tax
    0x6d, 0x00, 0x60,   # adc 0x6000
    0x8e, 0x00, 0x60,   # stx 0x6000

    # branch if value exceeded 255 (carry bit set)
    # jump 3 instructions forward
    0xb0, 0x03,         # bcs p+0x03

    # jump to calculation of next term
    0x4c, 0x0c, 0x80,   # jmp 0x800c

    # jump to setup of registers 
    0x4c, 0x05, 0x80    # jmp 0x8005

])

make_rom(rom)