draw:
    PUSH AF,DE

    LD A,(_saucer_state)

    BIT _SAUCER_STATE_ACTIVE_BIT,A
    JR NZ,.draw_saucer

    BIT _SAUCER_STATE_EXPLODING_BIT,A
    JR NZ,.draw_explosion

    BIT _SAUCER_STATE_SHOWING_SCORE_BIT,A
    JR NZ,.draw_score

    JR .done

.draw_saucer:
    CALL _draw_saucer

    JR .done

.draw_explosion:
    CALL _draw_explosion
    
    JR .done

.draw_score:
    CALL _draw_score
    ; Fall through

.done
    POP DE,AF

    RET

_draw_score:
    PUSH AF,DE

    LD DE,(_score)                                       ; Grab the current score
    PUSH DE                                             
    LD A, (_saucer_x)                                    ; Saucer coords
    SRL A                                           
    SRL A
    SRL A
    LD D,A
    LD E, layout.SAUCER_Y/8                             
    PUSH DE
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP DE
    POP DE

    POP DE,AF

    RET

_draw_explosion:
    PUSH AF,DE

    LD A, (_saucer_x)                                    ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET
_draw_saucer:
    PUSH AF,DE

    LD A, (_saucer_x)                                   ; Saucer base coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

blank:
    PUSH AF,DE

    LD A,(_saucer_state)

    BIT _SAUCER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    BIT _SAUCER_STATE_ACTIVE_BIT,A
    JR NZ,.blank_saucer

    BIT _SAUCER_LEAVING_SCREEN_BIT,A
    JR NZ,.blank_saucer
    
    BIT _SAUCER_STATE_DONE_SHOWING_SCORE_BIT,A
    JR NZ,.blank_score

    JR .done

.blank_saucer:
    CALL _blank_saucer

    JR .done

.blank_explosion
    CALL _blank_explosion

    JR .done

.blank_score
    CALL _blank_score
    ; Fall through

.done
    POP DE,AF

    RET
_blank_saucer:
    PUSH AF,DE

    LD A, (_saucer_x)                                    ; Saucer base coords
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

    POP DE,AF

    RET

_blank_explosion
    PUSH AF,DE

    LD A, (_saucer_x)                                    ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

_blank_score
    PUSH AF,DE

    LD DE,.SCORE_BLANK_STRING
    PUSH DE
    LD A, (_saucer_x)                                    ; Saucer coords
    SRL A                                                ; Divide by 8 to make character coords
    SRL A   
    SRL A
    LD D,A
    LD E, layout.SAUCER_Y/8                             
    PUSH DE
    CALL print.print_string
    POP DE
    POP DE
    
    POP DE,AF

    RET

.SCORE_BLANK_STRING: BYTE "    ",0