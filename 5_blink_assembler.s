PORTB = $6000
PDIRB = $6002

    .org $8000

reset:
    lda #$ff
    sta PDIRB
    lda #$50
    sta PORTB

loop:
    ror
    sta PORTB
    jmp loop

    .org $fffc
    .word reset
    .word $eaea