event_alien_missile_hit_player:
    LD A,_PLAYER_STATE_HIT_VALUE
    LD (player_state),A

    RET