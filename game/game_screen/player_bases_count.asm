print_player_bases_count:
    PUSH HL

    LD HL,.dummy_bases_count
    PUSH HL
    LD HL,layout.PLAYER_COUNT_CHAR_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    
    POP HL

    RET

.dummy_bases_count: BYTE "3",0
