;------------------------------------------------------------------------------
; Process alien landed/alien missile hitting player
;
; Usage:
;    CALL event_alien_landed_begin/event_alien_missile_hit_player
;------------------------------------------------------------------------------

event_alien_landed_begin:
event_alien_missile_hit_player:
    PUSH AF,HL

    LD HL,player_lives_1
    LD A,(HL)
    DEC A
    LD (HL),A
    
    POP HL,AF

    RET

