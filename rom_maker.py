def make_rom(rom, filename="rom.bin"):
    rom += bytearray([0xea] * (0x8000 - len(rom)))
    rom[0x7ffc] = 0x00
    rom[0x7ffd] = 0x80

    with open(filename, "wb") as rom_file:
        rom_file.write(rom)
