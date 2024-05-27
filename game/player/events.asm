event_alien_missile_hit_player_begin:
    PUSH AF

    LD A,(player_state)
    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR Z,.not_exploding

    LD A,_PLAYER_STATE_DONE_EXPLODING_VALUE
    LD (player_state),A

.not_exploding
    CALL blank

    LD A,_PLAYER_STATE_EXPLODING_VALUE
    LD (player_state),A

    POP AF

    RET

event_alien_missile_hit_player_end:
    PUSH AF
    
    CALL blank
    LD A,_PLAYER_STATE_DONE_EXPLODING_VALUE
    LD (player_state),A

    POP AF
    RET
