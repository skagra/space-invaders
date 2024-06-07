set_font:
.PARAM_FONT: EQU 8
    PUSH DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD DE,(IX+.PARAM_FONT)
    LD HL,character_set

    LD (HL),DE

    POP IX,HL,DE

    RET

