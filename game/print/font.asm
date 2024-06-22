set_font:

.PARAM_FONT: EQU 0

    PUSH DE,HL,IX

    PARAMS_IX 3                                         ; Get the stack pointer

    LD DE,(IX+.PARAM_FONT)
    LD HL,character_set

    LD (HL),DE

    POP IX,HL,DE

    RET

