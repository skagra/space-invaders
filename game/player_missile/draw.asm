;------------------------------------------------------------------------------
;
; Erases the current player missile or player missile explosion 
; based on (_missile_state).
;
; Usage:
;   CALL blank_missile
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _missile_state - State of the missile taken from _MISSILE_STATE_*
;   _missile_x - X coord of the missile
;   _missile_blank_y - Y coord of the missile
;
; External state:
;   -
;
;------------------------------------------------------------------------------

blank:
    PUSH AF,DE

    ; If missile is done at the top of the screen then there is an explosion to erase
    LD A,(_missile_state)
    BIT _MISSILE_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    BIT _MISSILE_STATE_HIT_A_SHIELD_BIT,A
    JR NZ,.explosion

    ; If the missile is active, has reach the top of the screen or has collided with something
    ; then there is a missile to erase
    AND _MISSILE_STATE_ACTIVE | _MISSILE_STATE_REACHED_TOP_OF_SCREEN | _MISSILE_STATE_NEW 
    JR NZ,.missile

    JR .done

.missile:
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
    
    LD D,0x00
    LD E,utils.TRUE_VALUE    
    PUSH DE 

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile 
    
    POP DE  
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done
    
.explosion:
    ; Erase explosion
    LD A,(_missile_x)                                    ; Coords
    LD D,A

    LD A,(_missile_state)
    BIT _MISSILE_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    LD A,(_missile_y)
    JR NZ,.explosion_at_top_of_screen
    DEC A                                               ; TODO Hack to get shield descruction working!
    DEC A                                               ; But breaks top of screen erasure - Must be a better solution

.explosion_at_top_of_screen:
    LD E,A                                              ; than branching on state here?
    PUSH DE
         
    LD DE, sprites.PLAYER_MISSILE_EXPLOSION_DIMS        ; Dimensioons
    PUSH DE

    LD DE,sprites.PLAYER_MISSILE_EXPLOSION              ; Sprite mask  
    PUSH DE

    LD D,0x00
    LD E,utils.TRUE_VALUE
    PUSH DE 

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile explosion
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
;
; Draws the current player missile or player missile explosion 
; based on (_missile_state).
;
; Usage:
;   CALL draw_missile
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _missile_state - Current state of the missile, values from _MISSILE_STATE_*
;   _missile_x - X coord of the missile
;   _missile_draw_y -Y coordinate of the missile
;
; External state:
;   -
;
;------------------------------------------------------------------------------

draw:
    PUSH AF,DE

    ; If the missile has reached the top of the screen then draw an explosion
    LD A,(_missile_state)
    BIT _MISSILE_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    ; If the missile is new or active then draw a missile 
    LD A,(_missile_state)
    AND _MISSILE_STATE_NEW | _MISSILE_STATE_ACTIVE 
    JR NZ,.missile

    JR .done

.missile
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

    JR .done

.explosion:
    ; Draw explosion
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

.done:
    POP DE,AF

    RET
