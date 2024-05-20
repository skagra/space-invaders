;------------------------------------------------------------------------------
;
; Routines to implement the player missile
;
;------------------------------------------------------------------------------

; Configuration constants
_MISSILE_STEP_SIZE:                         EQU 4                               ; Number of pixels to move missile on each animation cycle
_MISSILE_EXPLOSION_CYCLES:                  EQU 10                              ; Number of draw cycles to keep the missile explosion on the screen

; Bullet state masks
_MISSILE_STATE_NO_MISSILE:                  EQU 0b00000001                      ; No currently active missile
_MISSILE_STATE_NEW:                         EQU 0b00000010                      ; A new missile 
_MISSILE_STATE_ACTIVE:                      EQU 0b00000100                      ; Active missile travelling up the screen
_MISSILE_STATE_REACHED_TOP_OF_SCREEN:       EQU 0b00001000                      ; Bullet has reached the top of the screen
_MISSILE_STATE_AT_TOP_OF_SCREEN:            EQU 0b00010000                      ; Retain expoding image at top of screen
_MISSILE_STATE_DONE_AT_TOP_OF_SCREEN:       EQU 0b00100000                      ; At top of screen and missile is done
; _MISSILE_STATE_COLLIDED:                    EQU 0b01000000                      ; The missile has collided with something
_MISSILE_STATE_HIT_A_SHIELD:                EQU 0b10000000                      ; The missile has collided with a shield

; Bullet state mask bit positions
_MISSILE_STATE_NO_MISSILE_BIT:              EQU 0                   
_MISSILE_STATE_NEW_BIT:                     EQU 1                   
_MISSILE_STATE_ACTIVE_BIT:                  EQU 2                   
_MISSILE_STATE_REACHED_TOP_OF_SCREEN_BIT:   EQU 3   
_MISSILE_STATE_AT_TOP_OF_SCREEN_BIT         EQU 4               
_MISSILE_STATE_DONE_AT_TOP_OF_SCREEN_BIT:   EQU 5                  
; _MISSILE_STATE_COLLIDED_BIT:                EQU 6
_MISSILE_STATE_HIT_A_SHIELD_BIT:            EQU 7

_missile_state:                             BLOCK 1     ; Current state of the missile from _MISSILE_STATE_*
_missile_coords:
_missile_y:                                 BLOCK 1     ; Y coord to blank missile
_missile_x:                                 BLOCK 1     ; X coordinate of the missile, this never changes once a missile is running
_missile_explosion_cycle_count:             BLOCK 1     ; Count of cycles remaining to display missile explosion
_can_fire:                                  BLOCK 1

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
    LD (HL),_MISSILE_STATE_NO_MISSILE

    ; OK to fire (no alien exploding)
    LD HL,_can_fire
    LD (HL),utils.TRUE_VALUE

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
    AND _MISSILE_STATE_ACTIVE | _MISSILE_STATE_REACHED_TOP_OF_SCREEN | _MISSILE_STATE_NEW ; | _MISSILE_STATE_COLLIDED |
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
    DEC A                                               ; TODO XXX Hack to get shield descruction working!
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
;   _missile_state - Current state of the missile, values from _MISSILE_STATE_*
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

update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_missile_state)

    ; Is there a missile on the screen?
    BIT _MISSILE_STATE_NO_MISSILE_BIT,A
    JR NZ,.no_missile

    ; New missile?
    BIT _MISSILE_STATE_NEW_BIT,A
    JR NZ,.new

    ; Do we have an active missile?
    BIT _MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; Are we at the top of the screen?
    BIT _MISSILE_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.reached_top_of_screen 

    ; Are we in the loop keep the missile explosion displayed?
    BIT _MISSILE_STATE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.at_top_of_screen 

    ; Are we done expoding the missile at top of screen?
    BIT _MISSILE_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JP NZ,.done_at_top_of_screen 

    ; Has the missile collided with something?
    ; BIT _MISSILE_STATE_COLLIDED_BIT,A
    ; JP NZ,.collided

    ; Hit a base?
    BIT _MISSILE_STATE_HIT_A_SHIELD_BIT,A
    JP NZ,.missile_state_hit_a_shield

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JP .done    

.no_missile
    ; No current missile - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JP Z,.done                                          ; No

    LD A,(_can_fire)
    BIT utils.TRUE_BIT,A
    JR Z,.done

    ; Fire pressed - init a new missile
    LD HL,_missile_state                                 
    LD (HL),_MISSILE_STATE_NEW

    ; Calculate start x coord for missile
    LD A,(player.player_x)
    ADD A,0x04
    LD HL,_missile_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,layout.PLAYER_MISSILE_START_Y 
    LD HL,_missile_y       
    LD (HL),A

    JR .done

.new:
    LD HL,_missile_state                                
    LD (HL),_MISSILE_STATE_ACTIVE

    JR .done

.active:
    ; Check whether the missile has reached to top of the screen
    LD A,(_missile_y)
    CP A,layout.PLAYER_MISSILE_MIN_Y
    JR C,.active_reached_top_of_screen

    ; Active missile moving up the screen
    LD A,(_missile_y)
    SUB _MISSILE_STEP_SIZE
    LD (_missile_y),A
    
    JR .done

.active_reached_top_of_screen:
    LD HL,_missile_state                                                 
    LD (HL),_MISSILE_STATE_REACHED_TOP_OF_SCREEN

    JR .done

; .active_collision_detected:
;     ; LOGPOINT [COLLISION] Player missile collision detected x=${b@(draw_common.collision_x)} y=${b@(draw_common.collision_y)}

;     LD HL,_missile_state                                                 
;     LD (HL),_MISSILE_STATE_COLLIDED

;     JR .done

.reached_top_of_screen:
    LD HL,_missile_state                                                 
    LD (HL),_MISSILE_STATE_AT_TOP_OF_SCREEN
    LD HL, _missile_explosion_cycle_count
    LD (HL),_MISSILE_EXPLOSION_CYCLES

    JR .done

.at_top_of_screen:
    LD A,(_missile_explosion_cycle_count)
    DEC A
    LD (_missile_explosion_cycle_count),A
    JR NZ,.done
    LD HL,_missile_state                                                 
    LD (HL),_MISSILE_STATE_DONE_AT_TOP_OF_SCREEN

    JR .done

.done_at_top_of_screen:
    LD HL,_missile_state
    LD (HL),_MISSILE_STATE_NO_MISSILE

    JR .done

; .collided:
;     LD HL,_missile_state
;     LD (HL),_MISSILE_STATE_NO_MISSILE
;     JR .done

.hit_an_alien
    LD HL,_missile_state
    LD (HL),_MISSILE_STATE_NO_MISSILE

    JR .done

.missile_state_hit_a_shield
    LD HL,_missile_state
    LD (HL),_MISSILE_STATE_NO_MISSILE

    JR .done

.done
    POP HL,DE,BC,AF

    RET

event_player_missile_hit_alien:
    PUSH AF,HL

    CALL blank                                          ; Blank the missile missile immediately

    LD HL,_missile_state                                ; Set state to indicate we have no current missile
    LD (HL),_MISSILE_STATE_NO_MISSILE

    LD A,utils.FALSE_VALUE                              ; Can't fire another missile while an alien is exploding
    LD (_can_fire),A

    POP HL,AF
    
    RET 

event_alien_explosion_done:
    PUSH AF

    LD A,utils.TRUE_VALUE                               ; Alien done exploding, so allow player to fire missiles 
    LD (_can_fire),A

    POP AF

    RET

event_player_missile_hit_shield:
    PUSH HL
    
    LD HL,_missile_state                                ; Player missile has hit a shield, set state appropriately
    LD (HL),_MISSILE_STATE_HIT_A_SHIELD

    POP HL
    
    RET 
