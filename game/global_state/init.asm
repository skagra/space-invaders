init:
    RET

new_game:
    PUSH AF

    LD A,_GAME_STATE_RUNNING_VALUE
    LD (_game_state),A

    POP AF
    
    RET
