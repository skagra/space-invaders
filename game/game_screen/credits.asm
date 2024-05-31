print_credits:
    PUSH HL

    LD HL,(credits.credits)
    PUSH HL
    LD HL,layout.CREDITS_CHAR_COORDS
    PUSH HL
    CALL print.print_bcd_byte
    POP HL
    POP HL
    
    POP HL

    RET
