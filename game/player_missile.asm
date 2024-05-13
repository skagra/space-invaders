    MODULE player_missile

_module_start:

;------------------------------------------------------------------------------
;
; Routines to implement the player missile
;
; Usage:
;   CALL init
; .loop
;   CALL keyboard.get_movement_keys
;   HALT - Wait for raster retrace
;   CALL draw_missile
;   CALL update_missile
;   delay - tuned to wait for raster scan to leave bottom of visible screen
;   CALL erase_missile
;
;------------------------------------------------------------------------------

; Configuration constants
_BULLET_START_Y:                            EQU draw_common.SCREEN_HEIGHT_PIXELS-24    ; Starting Y coordinate for a new missile
_BULLET_MIN_Y:                              EQU 20                              ; The top of missile trajectory
_BULLET_STEP_SIZE:                          EQU 4                               ; Number of pixels to move missile on each animation cycle
_BULLET_EXPLOSION_CYCLES:                   EQU 10                              ; Number of draw cycles to keep the missile explosion on the screen

; Bullet state masks
_BULLET_STATE_NO_BULLET:                    EQU 0b00000001                      ; No currently active missile
_BULLET_STATE_NEW:                          EQU 0b00000010                      ; A new missile 
_BULLET_STATE_ACTIVE:                       EQU 0b00000100                      ; Active missile travelling up the screen
_BULLET_STATE_REACHED_TOP_OF_SCREEN:        EQU 0b00001000                      ; Bullet has reached the top of the screen
_BULLET_STATE_AT_TOP_OF_SCREEN:             EQU 0b00010000                      ; Retain expoding image at top of screen
_BULLET_STATE_DONE_AT_TOP_OF_SCREEN:        EQU 0b00100000                      ; At top of screen and missile is done
_BULLET_STATE_COLLIDED:                     EQU 0b01000000                      ; The missile has collided with something
_BULLET_STATE_HIT_A_SHIELD:                 EQU 0b10000000                      ; The missile has collided with a shield

; Bullet state mask bit positions
_BULLET_STATE_NO_BULLET_BIT:                EQU 0                   
_BULLET_STATE_NEW_BIT:                      EQU 1                   
_BULLET_STATE_ACTIVE_BIT:                   EQU 2                   
_BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT:    EQU 3   
_BULLET_STATE_AT_TOP_OF_SCREEN_BIT          EQU 4               
_BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT:    EQU 5                  
_BULLET_STATE_COLLIDED_BIT:                 EQU 6
_BULLET_STATE_HIT_A_SHIELD_BIT:             EQU 7

_collision_detected:                        BLOCK 1     ; Flags whether a collision was detected during the draw phase
_missile_state:                             BLOCK 1     ; Current state of the missile from _BULLET_STATE_*
_missile_coords:
_missile_y:                                 BLOCK 1     ; Y coord to blank missile
_missile_x:                                 BLOCK 1     ; X coordinate of the missile, this never changes once a missile is running
_missile_explosion_cycle_count:             BLOCK 1     ; Count of cycles remaining to display missile explosion

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

    ; No missile
    LD HL,_missile_state                         
    LD (HL),_BULLET_STATE_NO_BULLET

    ; Bullet has not collided with anything yet
    LD HL,_collision_detected
    LD (HL),0x00

    POP HL

    RET

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
;   _missile_state - State of the missile taken from _BULLET_STATE_*
;   _missile_x - X coord of the missile
;   _missile_blank_y - Y coord of the missile
;
; External state:
;   -
;
;------------------------------------------------------------------------------

blank_missile:
    PUSH AF,DE

    ; If missile is done at the top of the screen then there is an explosion to erase
    LD A,(_missile_state)
    BIT _BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    BIT _BULLET_STATE_HIT_A_SHIELD_BIT,A
    JR NZ,.explosion

    ; If the missile is active, has reach the top of the screen or has collided with something
    ; then there is a missile to erase
    AND _BULLET_STATE_ACTIVE | _BULLET_STATE_REACHED_TOP_OF_SCREEN | _BULLET_STATE_COLLIDED | _BULLET_STATE_NEW
    JR NZ,.missile

    JR .done

.missile:
    ; Erase the missile
    LD A,(_missile_x)                                    ; Coords
    LD D,A
    LD A,(_missile_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.sprite_player_missile_blank_dims      ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_player_missile_blank            ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile 

    POP DE
    POP DE
    POP DE

    JR .done
    
.explosion:
    ; Erase explosion
    LD A,(_missile_x)                                    ; Coords
    LD D,A

    LD A,(_missile_state)
    BIT _BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    LD A,(_missile_y)
    JR NZ,.explosion_at_top_of_screen
    DEC A                                               ; XXX Hack to get shield descruction working!
    DEC A                                               ; But breaks top of screen erasure - Must be a better solution

.explosion_at_top_of_screen:
    LD E,A                                              ; than branching on state here?
    PUSH DE
         
    LD DE, sprites.sprite_player_missile_explosion_blank_dims  ; Dimensioons
    PUSH DE

    LD DE,sprites.sprite_player_missile_explosion_blank  ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                               ; Erase the player missile explosion

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
;   _missile_state - Current state of the missile, values from _BULLET_STATE_*
;   _missile_x - X coord of the missile
;   _missile_draw_y -Y coordinate of the missile
;
; External state:
;   -
;
;------------------------------------------------------------------------------

draw_player_missile:
    PUSH AF,DE

    ; If the missile has reached the top of the screen then draw an explosion
    LD A,(_missile_state)
    BIT _BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.explosion

    ; If the missile is new or active then draw a missile 
    LD A,(_missile_state)
    AND _BULLET_STATE_NEW | _BULLET_STATE_ACTIVE 
    JR NZ,.missile

    JR .done

.missile
    ; Draw missile
    LD A, (_missile_x)                                   ; Coords
    LD D,A
    LD A, (_missile_y)
    LD E,A
    PUSH DE
    
    LD DE, sprites.sprite_player_missile_dims            ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_player_missile                  ; Sprite    
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player missile

    POP DE
    POP DE
    POP DE

    LD A,(draw_common.collided)                         
    LD DE,_collision_detected
    LD (DE),A

    JR .done

.explosion:
    ; Draw explosion
    LD A, (_missile_x)                                   ; Coords
    LD D,A
    LD A, (_missile_y)
    LD E,A
    PUSH DE
        
    LD DE, sprites.sprite_player_missile_explosion_dims  ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_player_missile_explosion        ; Sprite    
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the explosion

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
; Update the missile state based on its current state, location 
; and collision status
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
;   _missile_state - Current state of the missile, values from _BULLET_STATE_*
;   _missile_x - X coord of the missile
;   _missile_blank_y - Y coord to erase the missile
;   _missile_draw_y - Y coord to draw the missile
;   _collision_detected - Set to indicate a missile collision was detected in 
;       the draw phase
;
; External state:
;   keyboard.keys_down - To test for fire button being pressed
;   player.player_x - X coordinate of the player base
;
;------------------------------------------------------------------------------

update_missile:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_missile_state)

    ; Is there a missile on the screen?
    BIT _BULLET_STATE_NO_BULLET_BIT,A
    JR NZ,.no_missile

    ; New missile?
    BIT _BULLET_STATE_NEW_BIT,A
    JR NZ,.new

    ; Do we have an active missile?
    BIT _BULLET_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; Are we at the top of the screen?
    BIT _BULLET_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.reached_top_of_screen 

    ; Are we in the loop keep the missile explosion displayed?
    BIT _BULLET_STATE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.at_top_of_screen 

    ; Are we done expoding the missile at top of screen?
    BIT _BULLET_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JP NZ,.done_at_top_of_screen 

    ; Has the missile collided with something?
    BIT _BULLET_STATE_COLLIDED_BIT,A
    JP NZ,.collided

    ; Hit a base?
    BIT _BULLET_STATE_HIT_A_SHIELD_BIT,A
    JP NZ,.missile_state_hit_a_shield

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JP .done    

.no_missile
    ; No current missile - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JP Z,.done                                          ; No

    ; Fire pressed - init a new missile
    LD HL,_missile_state                                 
    LD (HL),_BULLET_STATE_NEW

    ; Calculate start x coord for missile
    LD A,(player.player_x)
    ADD A,0x04
    LD HL,_missile_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,_BULLET_START_Y 
    LD HL,_missile_y       
    LD (HL),A

    JR .done

.new:
    LD HL,_missile_state                                
    LD (HL),_BULLET_STATE_ACTIVE

    JR .done

.active:
    ; Check whether the missile has reached to top of the screen
    LD A,(_missile_y)
    CP A,_BULLET_MIN_Y
    JR C,.active_reached_top_of_screen

    ; Active missile moving up the screen
    LD A,(_missile_y)
    SUB _BULLET_STEP_SIZE
    LD (_missile_y),A
    
    JR .done

.active_reached_top_of_screen:
    LD HL,_missile_state                                                 
    LD (HL),_BULLET_STATE_REACHED_TOP_OF_SCREEN

    JR .done

.active_collision_detected:
    ; LOGPOINT [COLLISION] Player missile collision detected x=${b@(draw_common.collision_x)} y=${b@(draw_common.collision_y)}

    LD HL,_missile_state                                                 
    LD (HL),_BULLET_STATE_COLLIDED

    JR .done

.reached_top_of_screen:
    LD HL,_missile_state                                                 
    LD (HL),_BULLET_STATE_AT_TOP_OF_SCREEN
    LD HL, _missile_explosion_cycle_count
    LD (HL),_BULLET_EXPLOSION_CYCLES

    JR .done

.at_top_of_screen:
    LD A,(_missile_explosion_cycle_count)
    DEC A
    LD (_missile_explosion_cycle_count),A
    JR NZ,.done
    LD HL,_missile_state                                                 
    LD (HL),_BULLET_STATE_DONE_AT_TOP_OF_SCREEN

    JR .done

.done_at_top_of_screen:
    LD HL,_missile_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.collided:
    LD HL,_missile_state
    LD (HL),_BULLET_STATE_NO_BULLET
    JR .done

.hit_an_alien
    LD HL,_missile_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.missile_state_hit_a_shield
    LD HL,_missile_state
    LD (HL),_BULLET_STATE_NO_BULLET

    JR .done

.done
    POP HL,DE,BC,AF

    RET

missile_hit_alien:
    PUSH HL

    CALL blank_missile

    LD HL,_missile_state
    LD (HL),_BULLET_STATE_NO_BULLET

    POP HL
    
    RET 

missile_hit_a_shield:
    PUSH HL
    
    LD HL,_missile_state
    LD (HL),_BULLET_STATE_HIT_A_SHIELD

    POP HL
    
    RET 

    MEMORY_USAGE "player missile   ",_module_start

    ENDMODULE