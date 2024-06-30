;------------------------------------------------------------------------------
; Handle the player missile colliding with the saucer
; 
; Usage:
;   CALL event_player_missile_hit_saucer
;------------------------------------------------------------------------------
event_player_missile_hit_saucer:
    PUSH AF,DE,HL

    LD A,_STATE_EXPLODING_VALUE                         ; Set saucer to exploding state
    LD (_saucer_state),A

    LD A,_EXPLOSION_CYCLE_COUNT                         ; Initialize the count down to hold the explosion graphic                                         
    LD (_explosion_countdown),A

    ; Blank the saucer
    CALL _blank_saucer
 
    ; Update the score
    LD A,(player_missile.shot_count)                    ; Bottom 4 bits of shot count
    AND 0x0F
    LD H,0x00
    LD L,A
    LD DE,SAUCER_SCORES
    ADD HL,DE
    
    LD A,(HL)
    AND 0xF0                                            ; Grab the top nibble
    SRL A                                               ; Shift it down to lower nibble
    SRL A
    SRL A
    SRL A
    LD D,A                                              ; Becomes the lower nibble to MSB

    LD A,(HL)
    AND 0x0F                                            ; Grab the lower nibble
    SLA A                                               ; Shift it up to be the upper nibble
    SLA A
    SLA A
    SLA A
    LD E,A                                              ; Becomes the upper nibble of the LSB
                                            
    LD (_score),DE

    PUSH DE
    CALL scoring.add_to_score                           ; Update score
    POP DE
    CALL game_screen.print_score_player_1               ; Redraw score

    POP HL,DE,AF

    RET
