;------------------------------------------------------------------------------
; Process alien landed and alien hit by an alien missile
; 
; Usage:
;   CALL event_alien_landed_begin/event_alien_missile_hit_player_begin
;------------------------------------------------------------------------------

event_alien_landed_begin:
event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL

    CALL blank

    LD A,_PLAYER_STATE_EXPLODING_VALUE
    LD (_player_state),A

    LD A,_PLAYER_EXPLOSION_VARIANT_SWITCH_MAX
    LD (_player_explosion_variant_cycle_count),A

    LD HL,_player_explosion_variant_sprite
    LD DE,sprites.PLAYER_EXPLOSION_VARIANT_0
    LD (HL),DE

    POP HL,DE,AF

    RET

event_alien_landed_end:
event_alien_missile_hit_player_end:
    PUSH AF
    
    CALL blank ; TODO Not clear why this is needed

    LD A,_PLAYER_STATE_DONE_EXPLODING_VALUE
    LD (_player_state),A

    LD A,layout.PLAYER_START_X
    LD (player_x),A

    POP AF

    RET
