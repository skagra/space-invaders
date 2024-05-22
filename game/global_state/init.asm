init:
    LD A,_GAME_STATE_RUNNING_VALUE
    LD (_game_state),A
    RET