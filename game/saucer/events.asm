event_player_missile_hit_saucer:
    PUSH AF,DE,HL

    LD A,_SAUCER_STATE_EXPLODING_VALUE
    LD (_saucer_state),A

    LD A,30                                             ; TODO Pull out into constant
    LD (exploding_counter),A

    ; TODO Duplicate code

    ; Blank the saucer
    LD A, (saucer_x)                                    ; Saucer base coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    ; Set the score
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
                                            
    LD (score),DE

    PUSH DE
    CALL scoring.add_to_score
    POP DE
    CALL game_screen.print_score_player_1

    POP HL,DE,AF

    RET
