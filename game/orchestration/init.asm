init:
    RET

new_game:
    PUSH AF

    LD A,utils.TRUE_VALUE
    LD (_game_running),A

    POP AF
    
    RET

new_sheet:
    PUSH AF

    LD A,utils.FALSE_VALUE
    
    LD (_alien_exploding),A
    LD (_life_lost_pausing),A

    POP AF

    RET

