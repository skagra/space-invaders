print_game_over:
    PUSH HL

    LD HL,.GAME_OVER
    PUSH HL

    LD HL,layout.GAME_OVER_COORDS
    PUSH HL

    LD HL,print.slow_print_null_callback
    PUSH HL

    CALL print.slow_print_string
    
    POP HL
    POP HL
    POP HL
    
    POP HL

    RET

.GAME_OVER: BYTE "GAME OVER",0