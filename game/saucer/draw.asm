;------------------------------------------------------------------------------
; Draw the saucer/explosion/score
; 
; Usage:
;   CALL draw
;------------------------------------------------------------------------------
draw:
    PUSH AF

    ; Select draw behaviour based on saucer state
    LD A,(_saucer_state)

    BIT _STATE_ACTIVE_BIT,A
    JR NZ,.draw_saucer

    BIT _STATE_EXPLODING_BIT,A
    JR NZ,.draw_explosion

    BIT _STATE_SHOWING_SCORE_BIT,A
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
    POP AF

    RET

;------------------------------------------------------------------------------
; Draw the score
; 
; Usage:
;   CALL _draw_score
;------------------------------------------------------------------------------
_draw_score:
    PUSH AF,DE

    LD DE,(_score)                                       ; Grab the current score
    PUSH DE                                             
    LD A, (_saucer_x)                                    ; Saucer coords
    SRL A                                                ; Divide pixel coords by 8 
    SRL A                                                ; to give character coords
    SRL A
    LD D,A
    LD E, layout.SAUCER_Y/8                             
    PUSH DE
    CALL print.print_bcd_word                           ; Print the score
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the explosion
; 
; Usage:
;   CALL _draw_explosion
;------------------------------------------------------------------------------
_draw_explosion:
    PUSH AF,DE

    LD A, (_saucer_x)                                   ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Ignore the collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the explosion
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the saucer
; 
; Usage:
;   CALL _draw_saucer
;------------------------------------------------------------------------------
_draw_saucer:
    PUSH AF,DE

    LD A, (_saucer_x)                                   ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS                           ; Dims
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Ignore collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the saucer/explosion/score
; 
; Usage:
;   CALL blank
;------------------------------------------------------------------------------
blank:
    PUSH AF

    ; Select blank behaviour based on saucer state
    LD A,(_saucer_state)

    BIT _STATE_DONE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    BIT _STATE_ACTIVE_BIT,A
    JR NZ,.blank_saucer

    BIT _STATE_LEAVING_SCREEN_BIT,A
    JR NZ,.blank_saucer
    
    BIT _STATE_DONE_SHOWING_SCORE_BIT,A
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
    POP AF

    RET

;------------------------------------------------------------------------------
; Blank the saucer
; 
; Usage:
;   CALL _blank_saucer
;------------------------------------------------------------------------------
_blank_saucer:
    PUSH AF,DE

    LD A, (_saucer_x)                                   ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS                           ; Dims
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Ignore collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Blank the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the explosion
; 
; Usage:
;   CALL _blank_explosion
;------------------------------------------------------------------------------
_blank_explosion
    PUSH AF,DE

    LD A, (_saucer_x)                                   ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Ignore collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Blank the explosion
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the score
; 
; Usage:
;   CALL _blank_score
;------------------------------------------------------------------------------
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