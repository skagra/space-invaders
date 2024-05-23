event_alien_missile_hit_player:
    NOP
    ; LOGPOINT [PLAYER] YOU GOT ME
    ; LOGPOINT [PLAYER] --

    LD A,_PLAYER_STATE_HIT_VALUE
    LD (player_state),A

    RET