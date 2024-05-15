print_credits:
    PUSH HL

    LD HL,.dummy_credits
    PUSH HL
    LD HL,layout.CREDITS_CHAR_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    
    POP HL

    RET

.dummy_credits: BYTE "00",0
