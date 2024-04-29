    MODULE player_bullet

;------------------------------------------------------------------------------
;
; Initialise the module
;
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

init:
    PUSH AF

    LD HL,_bullet_state                         
    LD (HL),_BULLET_STATE_NO_BULLET

    POP AF

    RET

;------------------------------------------------------------------------------
;
; Erases the current player bullet or player bullet explosion 
; based on (_bullet_state).
;
; Usage:
;   CALL blank_bullet
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _bullet_state - Current state of the bullet, values from _BULLET_STATE_*
;   _bullet_x - X coord of the bullet
;   _bullet_current_y - Current Y coord of the bullet
;
; External state:
;   -
;
;------------------------------------------------------------------------------

blank_bullet:
    PUSH AF,DE

    ; Do we need to erase the bullet explosion?
    LD A,(_bullet_state)
    CP _BULLET_STATE_DONE
    JR Z,.bullet_state_done

    ; Is this a new bullet - so there is nothing to erase
    CP _BULLET_STATE_NEW
    JR Z,.done
    
    ; Is there an active bullet to draw?
    LD A,(_bullet_state)
    CP _BULLET_STATE_NO_BULLET
    JR Z,.done

    ; Erase old bullet
    LD A,(_bullet_x)                                    ; Coords
    LD D,A
    LD A,(_bullet_current_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0204                                       ; Player bullet dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_1b_x_4px                 ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                               ; Erase player bullet 

    POP DE
    POP DE
    POP DE
    POP DE

    JR .done
    
.bullet_state_done:
    ; Erase explosion
    LD A,(_bullet_x)                                    ; Coords
    LD D,A
    LD A,(_bullet_current_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0208                                       ; Explosion dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_1b_x_8px                 ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet_explosion        ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player bullet explosion

    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
;
; Draws the current player bullet or player bullet explosion 
; based on (_bullet_state).
;
; Usage:
;   CALL draw_bullet
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _bullet_state - Current state of the bullet, values from _BULLET_STATE_*
;   _bullet_x - X coord of the bullet
;   _bullet_new_y - New Y coord of the bullet
;
; External state:
;   -
;
;------------------------------------------------------------------------------

draw_bullet:
    PUSH AF,DE

    LD A,(_bullet_state)

    CP _BULLET_STATE_EXPLODING
    JR Z,.bullet_exploding

    CP _BULLET_STATE_NEW
    JR Z,.active_bullet

    CP _BULLET_STATE_ACTIVE
    JR Z,.active_bullet

    JR .done

.active_bullet
    ; Draw bullet
    LD A, (_bullet_x)                                   ; Player bullet
    LD D,A
    LD A, (_bullet_new_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0204                                       ; Player bullet dimensions
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Sprite mask 
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite

    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.bullet_exploding:
    ; Draw explosion
    LD A, (_bullet_x)                                   ; Coords
    LD D,A
    LD A, (_bullet_new_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0208                                       ; Player bullet explosion dimensions
    PUSH DE

    LD DE,sprites.sprite_player_bullet_explosion        ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet_explosion        ; Sprite mask 
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite

    POP DE
    POP DE
    POP DE
    POP DE

.done:
    POP DE,AF

    RET

_BULLET_STEP_SIZE:          EQU 4                       ; Number of pixels to move bullet on each animation cycle
_bullet_state:              BLOCK 1                     ; Current state of the bullet from _BULLET_STATE_*
_BULLET_STATE_NO_BULLET:    EQU 0x00                    ; There is no currently active bullet
_BULLET_STATE_NEW:          EQU 0x01                    ; A new bullet - so nothing to erase
_BULLET_STATE_ACTIVE:       EQU 0x02                    ; There is an active bullet travelling up the screen
_BULLET_STATE_EXPLODING     EQU 0x03                    ; The bullet is exploding
_BULLET_STATE_DONE:         EQU 0x04                    ; The explosion of the bullet is complete - time to allow a new bullet
_bullet_current_y:          BLOCK 1                     ; Y coordination of the bullet currently - used to erase the "old" bullet in blank_bullet
_bullet_new_y:              BLOCK 1                     ; The Y coordinate of the bullet for the next draw cycle - used in draw_bullet
_bullet_x:                  BLOCK 1                     ; X coordinate of the bullet, this never changes once a bullet is running
_BULLET_MIN_Y:              EQU   24                    ; The top of bullet trajectory, the bullet will change to an exploding state if it gets this far

;------------------------------------------------------------------------------
;
; Update the bullet state based on its current state and location
;
; Usage:
;   CALL blank_bullet
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _bullet_state - Current state of the bullet, values from _BULLET_STATE_*
;   _bullet_x - X coord of the bullet
;   _bullet_current_y - Current Y coord of the bullet
;   _bullet_new_y - New Y coord of the byllet
;
; External state:
;   keyboard.keys_down - To test for fire button being pressed
;   player.player_x - X coordinate of the player base
;
;------------------------------------------------------------------------------
update_bullet:
    PUSH AF,BC,DE,HL

    ; Grab the current bullet state
    LD A,(_bullet_state)

    ; Is there a currently active bullet?
    CP _BULLET_STATE_NO_BULLET
    JR Z,.no_current_bullet

    ; Are we already at the top of screen and exploding
    CP _BULLET_STATE_EXPLODING
    JR Z,.bullet_state_exploding 

    ; Explosion complete time to allow a new bullet
    CP _BULLET_STATE_DONE
    JR Z,.bullet_state_done

    ; Do we have an active bullet?
    CP _BULLET_STATE_ACTIVE
    JR Z,.bullet_state_active

    ; Must be a new bullet
    LD HL,_bullet_state                                                 
    LD (HL),_BULLET_STATE_ACTIVE

    JR .done

.bullet_state_active:
    ; Check whether the bullet has reached to top of the screen
    LD A,(_bullet_current_y)
    CP A,_BULLET_MIN_Y
    JR C,.start_explosion

    ; Active bullet moving up the screen
    LD A,(_bullet_new_y)
    LD (_bullet_current_y),A
    LD B,_BULLET_STEP_SIZE   
    SUB B
    LD (_bullet_new_y),A
    
    JR .done

.start_explosion:
    ; The bullet has just reached the top of the screen
    ; The next draw_bullet call will draw the explosion
    LD HL,_bullet_state                                 ; Set bullet state to exploding                  
    LD (HL),_BULLET_STATE_EXPLODING
    LD A,(_bullet_new_y)                                ; The bullet is now stationary
    LD (_bullet_current_y),A

    JR .done

.bullet_state_exploding:
    ; The last cycle drew the explosion.
    ; So now we are done and we'll just erase the explosion on next blank_bullet call
    LD HL,_bullet_state
    LD (HL),_BULLET_STATE_DONE

    JR .done

.bullet_state_done:
    ; The bullet has exploded, and the explosion erased so allow a new bullet 
    ; to be fired
    LD HL,_bullet_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.no_current_bullet
    ; No current bullet - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JR Z,.done                                          ; No

    ; Fire pressed - init a new bullet
    LD HL,_bullet_state                                 ; We now have an active bullet
    LD (HL),_BULLET_STATE_NEW

    ; Calculate start x coord for bullet
    LD A,(player.player_x)
    ADD A,0x04
    LD HL,_bullet_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,draw.SCREEN_HEIGHT_PIXELS-16    
    LD HL,_bullet_current_y       
    LD (HL),A
    LD HL,_bullet_new_y       
    LD (HL),A

.done
    POP HL,DE,BC,AF

    RET

    ENDMODULE