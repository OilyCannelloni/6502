; 7_hello_world
; Prints "Hello, World" onto the LCD
; RAM required

PORTA = $6001  ; 65c22 ports
PORTB = $6000
DDRA = $6003   ; Data direction registers
DDRB = $6002

E  = %00000100 ; LCD Enable
RW = %00000010 ; LCD Read/Write
RS = %00000001 ; LCD Register Select

    .org $8000

reset:
    lda #%11111111 ; Set all pins on PORT A to output
    sta DDRA
    lda #%00000111 ; Set bottom 3 pins of PORT B to output
    sta DDRB

    lda #%00111000 ; Set 8-bit communication, 2 lines and narrow font
    jsr lcd_cmd

    lda #%00001111 ; Set display ON, cursor ON, blinking ON
    jsr lcd_cmd

    lda #%00000110 ; Set cursor incrementation, no screen shifting
    jsr lcd_cmd


    ldx hello_len  ; Load length of message to X register
hello_loop:
    dex
    lda hello, x   ; Load x-th char of message
    jsr lcd_putc   ; Print the char
    txa
    beq loop       ; Check if the whole message has been printed
    tax
    jmp hello_loop

loop:
    jmp loop


lcd_putc:        ; Prints a character stored in A register to the LCD
    sta PORTA 
    lda #RS      ; Reset LCD control pins
    sta PORTB
    lda #(E | RS)       ; Set ENABLE and REG_SELECT bits
    sta PORTB
    lda #RS     ; Reset ENABLE bit
    sta PORTB
    rts

lcd_cmd: ; Applies an instruction loaded in A register
    sta PORTA 
    lda #0       ; Reset LCD control pins
    sta PORTB
    lda #E       ; Set ENABLE bit
    sta PORTB
    lda #0       ; Reset LCD control pins
    sta PORTB
    rts

hello_len: .word 12
hello: .asciiz "dlroW ,olleH"

    .org $fffc
    .word reset
    .word $eaea 
 
