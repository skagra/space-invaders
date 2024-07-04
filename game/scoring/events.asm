;------------------------------------------------------------------------------
; Handle event where an alien is hit by a player missile
; 
; Usage:
;   PUSH rr                                 ; Alien type
;   CALL event_alien_hit_by_player_missile
;   POP rr
;------------------------------------------------------------------------------

event_alien_hit_by_player_missile:

.PARAM_ALIEN_TYPE EQU 0

    PUSH AF,BC,HL,IX

    PARAMS_IX 4                                         ; Point IX at the first stack parameter

    LD HL,.ALIEN_SCORE_VALUES                           ; Alien score lookup table
    LD B,0x00                                               
    LD C,(IX+.PARAM_ALIEN_TYPE)                         ; Alien type gives index into table
    ADD HL,BC                                           ; Add the index to the base
    LD C,(HL)                                           ; Grab the alien score value
    
    PUSH BC                                             ; Add the alien score value to the current score
    CALL add_to_score
    POP BC

    POP IX,HL,BC,AF

    RET

; Alien scores index by the alien type
.ALIEN_SCORE_VALUES: BYTE 0x10,0x20,0x30

event_game_over:
    PUSH AF,HL

    LD A,(score_msb_player_1)
    LD HL,(score_high)
    CP H
    JR C,.done
    JR NZ,.update

    LD A,(score_lsb_player_1)
    CP L
    JR C,.done

.update
    LD A,(score_msb_player_1)
    LD (score_msb_high),A

    LD A,(score_lsb_player_1)
    LD (score_lsb_high),A

.done
    POP HL,AF

    RET
