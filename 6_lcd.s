
PORTA = $6001
PORTB = $6000
DDRA = $6003
DDRB = $6002

E  = %00000100
RW = %00000010
RS = %00000001

    .org $8000

reset:
    lda #%11111111 ; Set all pins on PORT A to output
    sta DDRA
    lda #%00000111 ; Set bottom 3 pins of PORT B to output
    sta DDRB

    lda #%00111000 ; Set 8-bit communication, 2 lines and narrow font
    sta PORTA 
    lda #0 ; Apply instruction
    sta PORTB
    lda #E
    sta PORTB
    lda #0
    sta PORTB

    lda #%00001111 ; Set display ON, cursor ON, blinking ON
    sta PORTA 
    lda #0 ; Apply instruction
    sta PORTB
    lda #E
    sta PORTB
    lda #0
    sta PORTB

    lda #%00000110
    sta PORTA 
    lda #0 ; Apply instruction
    sta PORTB
    lda #E
    sta PORTB
    lda #0
    sta PORTB

    lda #"H"
    sta PORTA 
    lda #0 ; Apply instruction
    sta PORTB
    lda #(E | RS)
    sta PORTB
    lda #RS
    sta PORTB
    lda #0
    sta PORTB

loop:
    jmp loop

    .org $fffc
    .word reset
    .word $eaea 
    



