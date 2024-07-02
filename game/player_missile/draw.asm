;------------------------------------------------------------------------------
; Erase the player missile or player missile explosion 
; based on (_missile_state).
;
; Usage:
;   CALL blank
;------------------------------------------------------------------------------

blank:
    PUSH AF,DE

    LD A,(_missile_state)

    ; Missile at top of screen?
    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A
    JR Z,.not_at_top_of_screen

    ; Top of screen sub-states
    LD A,(_tos_sub_state)
    BIT _TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    BIT _TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.missile

    JR .done

.not_at_top_of_screen
    LD A,(_missile_state)

    AND _MISSILE_STATE_ACTIVE_VALUE |  _MISSILE_STATE_MISSILES_COLLIDED_VALUE
    JR NZ,.missile

    JR .done

.missile:
    CALL _blank_missile
    JR .done
    
.explosion:
    CALL _blank_explosion
    ; Fall through

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Erase the player missile.
;
; Usage:
;   CALL _blank_missile
;------------------------------------------------------------------------------

_blank_missile:
    PUSH AF,DE

    ; Erase the missile
    LD A,(_missile_x)                                   ; Coords
    LD D,A
    LD A,(_missile_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.PLAYER_MISSILE_DIMS                  ; Dimensions
    PUSH DE

    LD DE,sprites.PLAYER_MISSILE                        ; Sprite/mask  
    PUSH DE
                               
    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE 

    LD DE,collision.dummy_collision                     ; Ignore collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile 
    
    POP DE  
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Erase the player missile explosion.
;
; Usage:
;   CALL _blank_explosion
;------------------------------------------------------------------------------

_blank_explosion:
    PUSH AF,DE

    LD A,(_missile_x)                                   ; Coords
    LD D,A
    LD A,(_missile_y)
    LD E,A
    PUSH DE
         
    LD DE, sprites.PLAYER_MISSILE_EXPLOSION_DIMS        ; Dimensions
    PUSH DE

    LD DE,sprites.PLAYER_MISSILE_EXPLOSION              ; Sprite mask  
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE 

    LD DE,collision.dummy_collision                     ; Ignore collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile explosion
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the player missile or explosion based on (_missile_state).
;
; Usage:
;   CALL draw
;------------------------------------------------------------------------------

draw:
    PUSH AF,DE

    LD A,(_missile_state)

    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A              ; At top of screen?
    JR Z,.not_at_top_of_screen                          

    LD A,(_tos_sub_state)

    BIT _TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    JR .done

.not_at_top_of_screen:
    
    LD A,(_missile_state)

    BIT _MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.missile

    JR .done

.missile
    CALL _draw_missile

    JR .done

.explosion:
    CALL _draw_explosion
    ; Fall through

.done:
    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the player missile.
;
; Usage:
;   CALL _draw_missile
;------------------------------------------------------------------------------

_draw_missile:
    PUSH AF,DE

    ; Draw missile
    LD A, (_missile_x)                                  ; Coords
    LD D,A
    LD A, (_missile_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.PLAYER_MISSILE_DIMS                  ; Dimensions
    PUSH DE

    LD DE,sprites.PLAYER_MISSILE                        ; Sprite    
    PUSH DE

    LD D,0x00
    LD E,utils.FALSE_VALUE
    PUSH DE 

    LD DE,collision.player_missile_collision            ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player missile
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the player missile explosion.
;
; Usage:
;   CALL _draw_explosion
;------------------------------------------------------------------------------

_draw_explosion:
    PUSH AF,DE

    LD A, (_missile_x)                                  ; Coords
    LD D,A
    LD A, (_missile_y)
    LD E,A
    PUSH DE
        
    LD DE, sprites.PLAYER_MISSILE_EXPLOSION_DIMS        ; Dimensions
    PUSH DE

    LD DE,sprites.PLAYER_MISSILE_EXPLOSION              ; Sprite    
    PUSH DE

    LD D,0x00
    LD E,utils.FALSE_VALUE
    PUSH DE 

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the explosion
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    POP DE,AF

    RET