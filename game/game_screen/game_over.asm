print_game_over:
    PUSH HL

    LD HL,.GAME_OVER
    PUSH HL

    LD HL,layout.GAME_OVER_COORDS
    PUSH HL

    CALL print.print_string
    
    POP HL
    POP HL

    POP HL

    RET

.GAME_OVER: BYTE "GAME OVER",0