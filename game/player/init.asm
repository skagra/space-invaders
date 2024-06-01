init:
    RET

new_game:
    PUSH AF,DE,HL

    LD A,layout.PLAYER_START_X
    LD (player_x),A

    LD A,_PLAYER_STATE_ACTIVE_VALUE
    LD (player_state),A

    POP HL,DE,AF

    RET