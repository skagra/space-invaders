    MODULE player_bullet

;------------------------------------------------------------------------------
;
; Routines to implement the player bullet
;
; Usage:
;   CALL init
; .loop
;   CALL keyboard.get_movement_keys
;   HALT - Wait for raster retrace
;   CALL draw_bullet
;   CALL update_bullet
;   delay - tuned to wait for raster scan to leave bottom of visible screen
;   CALL erase_bullet
;
;------------------------------------------------------------------------------

; Configuration constants
_BULLET_START_Y:                            EQU draw.SCREEN_HEIGHT_PIXELS-20    ; Starting Y coordinate for a new bullet
_BULLET_MIN_Y:                              EQU 18                              ; The top of bullet trajectory
_BULLET_STEP_SIZE:                          EQU 4                               ; Number of pixels to move bullet on each animation cycle
_BULLET_EXPLOSION_CYCLES:                   EQU 10                              ; Number of draw cycles to keep the bullet explosion on the screen

; Bullet state masks
_BULLET_STATE_NO_BULLET:                    EQU 0b00000001                      ; No currently active bullet
_BULLET_STATE_NEW:                          EQU 0b00000010                      ; A new bullet 
_BULLET_STATE_ACTIVE:                       EQU 0b00000100                      ; Active bullet travelling up the screen
_BULLET_STATE_REACHED_TOP_OF_SCREEN:        EQU 0b00001000                      ; Bullet has reached the top of the screen
_BULLET_STATE_AT_TOP_OF_SCREEN:             EQU 0b00010000                      ; Retain expoding image at top of screen
_BULLET_STATE_DONE_AT_TOP_OF_SCREEN:        EQU 0b00100000                      ; At top of screen and bullet is done
_BULLET_STATE_COLLIDED:                     EQU 0b01000000                      ; The bullet has collided with something

; Bullet state mask bit positions
_BULLET_STATE_NO_BULLET_BIT:                EQU 0                   
_BULLET_STATE_NEW_BIT:                      EQU 1                   
_BULLET_STATE_ACTIVE_BIT:                   EQU 2                   
_BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT:    EQU 3   
_BULLET_STATE_AT_TOP_OF_SCREEN_BIT          EQU 4               
_BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT:    EQU 5                  
_BULLET_STATE_COLLIDED_BIT:                 EQU 6

_collision_detected:                        BLOCK 1                             ; Flags whether a collision was detected during the draw phase
_bullet_state:                              BLOCK 1                             ; Current state of the bullet from _BULLET_STATE_*
_bullet_blank_y:                            BLOCK 1                             ; Y coord to blank bullet
_bullet_draw_y:                             BLOCK 1                             ; Y coord to draw bullet
_bullet_x:                                  BLOCK 1                             ; X coordinate of the bullet, this never changes once a bullet is running
_bullet_explosion_cycle_count:              BLOCK 1                             ; Count of cycles remaining to display bullet explosion

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
    PUSH HL

    ; No bullet
    LD HL,_bullet_state                         
    LD (HL),_BULLET_STATE_NO_BULLET

    ; Bullet has not collided with anything yet
    LD HL,_collision_detected
    LD (HL),0x00

    POP HL

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
;   _bullet_state - State of the bullet taken from _BULLET_STATE_*
;   _bullet_x - X coord of the bullet
;   _bullet_blank_y - Y coord of the bullet
;
; External state:
;   -
;
;------------------------------------------------------------------------------

blank_bullet:
    PUSH AF,DE

    ; If bullet is done at the top of the screen then there is an explosion to erase
    LD A,(_bullet_state)
    BIT _BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    ; If the bullet is active, has reach the top of the screen or has collided with something
    ; then there is a bullet to erase
    AND _BULLET_STATE_ACTIVE | _BULLET_STATE_REACHED_TOP_OF_SCREEN | _BULLET_STATE_COLLIDED
    JR NZ,.bullet

    JR .done

.bullet:
    ; Erase the bullet
    LD A,(_bullet_x)                                    ; Coords
    LD D,A
    LD A,(_bullet_blank_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.sprite_player_bullet_dims            ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_1b_x_4px                 ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player bullet 

    POP DE
    POP DE
    POP DE
    POP DE

    JR .done
    
.explosion:
    ; Erase explosion
    LD A,(_bullet_x)                                    ; Coords
    LD D,A
    LD A,(_bullet_blank_y)
    LD E,A
    PUSH DE
         
    LD DE, sprites.sprite_player_bullet_explosion_dims  ; Dimensioons
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
;   _bullet_draw_y -Y coordinate of the bullet
;
; External state:
;   -
;
;------------------------------------------------------------------------------

draw_bullet:
    PUSH AF,DE

    ; If the bullet has reached the top of the screen then draw an explosion
    LD A,(_bullet_state)
    BIT _BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    ; If the bullet is new or active then draw a bullet 
    LD A,(_bullet_state)
    AND _BULLET_STATE_NEW | _BULLET_STATE_ACTIVE
    JR NZ,.bullet

    JR .done

.bullet
    ; Draw bullet
    LD A, (_bullet_x)                                   ; Coords
    LD D,A
    LD A, (_bullet_draw_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.sprite_player_bullet_dims            ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet                  ; Mask
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player bullet

    POP DE
    POP DE
    POP DE
    POP DE

    LD A,(draw.collided)
    LD DE,_collision_detected
    LD (DE),A

    JR .done

.explosion:
    ; Draw explosion
    LD A, (_bullet_x)                                   ; Coords
    LD D,A
    LD A, (_bullet_draw_y)
    LD E,A
    PUSH DE
        
    LD DE, sprites.sprite_player_bullet_explosion_dims  ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_player_bullet_explosion        ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet_explosion        ; Mask 
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the explosion

    POP DE
    POP DE
    POP DE
    POP DE

    LD A,0x00
    LD DE,_collision_detected
    LD (DE),A

.done:
    POP DE,AF

    RET

;------------------------------------------------------------------------------
;
; Update the bullet state based on its current state, location 
; and collision status
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
;   _bullet_blank_y - Y coord to erase the bullet
;   _bullet_draw_y - Y coord to draw the bullet
;   _collision_detected - Set to indicate a bullet collision was detected in 
;       the draw phase
;
; External state:
;   keyboard.keys_down - To test for fire button being pressed
;   player.player_x - X coordinate of the player base
;
;------------------------------------------------------------------------------

update_bullet:
    PUSH AF,BC,DE,HL

    ; Default is the bullet does not move
    LD A,(_bullet_draw_y)                                
    LD (_bullet_blank_y),A

    ; Grab the current bullet state
    LD A,(_bullet_state)

    ; Is there a bullet on the screen?
    BIT _BULLET_STATE_NO_BULLET_BIT,A
    JR NZ,.no_bullet

    ; New bullet?
    BIT _BULLET_STATE_NEW_BIT,A
    JR NZ,.new

    ; Do we have an active bullet?
    BIT _BULLET_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; Are we at the top of the screen?
    BIT _BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.reached_top_of_screen 

    ; Are we in the loop keep the bullet explosion displayed?
    BIT _BULLET_STATE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.at_top_of_screen 

    ; Are we done expoding the bullet at top of screen?
    BIT _BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.done_at_top_of_screen 

    ; Has the bullet collided with something?
    BIT _BULLET_STATE_COLLIDED_BIT,A
    JR NZ,.collided

    // This should never be reached!
    JR .done    

.no_bullet
    ; No current bullet - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JR Z,.done                                          ; No

    ; Fire pressed - init a new bullet
    LD HL,_bullet_state                                 
    LD (HL),_BULLET_STATE_NEW

    ; Calculate start x coord for bullet
    LD A,(player.player_x)
    ADD A,0x04
    LD HL,_bullet_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,_BULLET_START_Y 
    LD HL,_bullet_blank_y       
    LD (HL),A
    LD HL,_bullet_draw_y       
    LD (HL),A

    JR .done

.new:
    LD HL,_bullet_state                                
    LD (HL),_BULLET_STATE_ACTIVE

    JR .done

.active:
    ; Check whether the bullet has reached to top of the screen
    LD A,(_bullet_blank_y)
    CP A,_BULLET_MIN_Y
    JR C,.active_reached_top_of_screen

    ; Check whether a collision has been flagged
    LD A,(_collision_detected)
    CP 0x01
    JR Z,.active_collision_detected

    ; Active bullet moving up the screen
    LD A,(_bullet_draw_y)
    LD (_bullet_blank_y),A
    LD B,_BULLET_STEP_SIZE   
    SUB B
    LD (_bullet_draw_y),A
    
    JR .done

.active_reached_top_of_screen:
    LD HL,_bullet_state                                                 
    LD (HL),_BULLET_STATE_REACHED_TOP_OF_SCREEN

    JR .done

.active_collision_detected:
    LD HL,_bullet_state                                                 
    LD (HL),_BULLET_STATE_COLLIDED

    JR .done

.reached_top_of_screen:
    LD HL,_bullet_state                                                 
    LD (HL),_BULLET_STATE_AT_TOP_OF_SCREEN
    LD HL, _bullet_explosion_cycle_count
    LD (HL),_BULLET_EXPLOSION_CYCLES

    JR .done

.at_top_of_screen:
    LD A,(_bullet_explosion_cycle_count)
    DEC A
    LD (_bullet_explosion_cycle_count),A
    JR NZ,.done
    LD HL,_bullet_state                                                 
    LD (HL),_BULLET_STATE_DONE_AT_TOP_OF_SCREEN

    JR .done

.done_at_top_of_screen:
    LD HL,_bullet_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.collided:
    LD HL,_bullet_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.done
    POP HL,DE,BC,AF

    RET

    ENDMODULE