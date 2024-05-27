event_alien_missile_hit_player_begin:
    PUSH AF

    LD A,utils.FALSE_VALUE
    LD (_can_fire),A

    LD A,(_missile_state)
    AND _MISSILE_STATE_AT_TOP_OF_SCREEN | _MISSILE_STATE_REACHED_TOP_OF_SCREEN  ; BUG
    JR Z,.not_at_top

    LD A,_MISSILE_STATE_DONE_AT_TOP_OF_SCREEN_BIT
    LD (_missile_state),A

.not_at_top
    CALL blank

    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    POP AF

    RET


event_alien_missile_hit_player_end:
    PUSH AF

    LD A,utils.TRUE_VALUE
    LD (_can_fire),A

    POP AF

    RET