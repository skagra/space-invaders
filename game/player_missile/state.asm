_MISSILE_STEP_SIZE:                         EQU 4               ; Number of Y pixels to move missile on each animation cycle
_MISSILE_EXPLOSION_CYCLES:                  EQU 10              ; Number of draw cycles to keep the missile explosion on the screen

; Bullet state masks
_MISSILE_STATE_NO_MISSILE_VALUE:            EQU 0b00000001      ; No currently active missile
_MISSILE_STATE_ACTIVE_VALUE:                EQU 0b00000010      ; Active missile travelling up the screen
_MISSILE_STATE_TOP_OF_SCREEN_VALUE:         EQU 0b00000100      ; Bullet has reached the top of the screen
_MISSILE_STATE_MISSILES_COLLIDED_VALUE:     EQU 0b00001000

; Bullet state mask bit positions
_MISSILE_STATE_NO_MISSILE_BIT:              EQU 0                   
_MISSILE_STATE_ACTIVE_BIT:                  EQU 1                   
_MISSILE_STATE_TOP_OF_SCREEN_BIT:           EQU 2                  
_MISSILE_STATE_MISSILES_COLLIDED_BIT:       EQU 3

_TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_VALUE: EQU 0b00000001      ; Bullet has reached the top of the screen
_TOS_SUB_STATE_AT_TOP_OF_SCREEN_VALUE:      EQU 0b00000010      ; Retain exploding image at top of screen
_TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_VALUE: EQU 0b00000100      ; At top of screen and missile is done

_TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_BIT:   EQU 0   
_TOS_SUB_STATE_AT_TOP_OF_SCREEN_BIT         EQU 1               
_TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_BIT:   EQU 2                  

_tos_sub_state:                             BLOCK 1             ; Sub state when missile is at top of screen
_missile_state:                             BLOCK 1             ; Current state of the missile from _MISSILE_STATE_*
_missile_coords:                                                ; Missile coordinates
_missile_y:                                 BLOCK 1             ; Y coord to blank missile
_missile_x:                                 BLOCK 1             ; X coordinate of the missile, this never changes once a missile is running
_missile_explosion_cycle_count:             BLOCK 1             ; Count of cycles remaining to display missile explosion

_can_fire:                                  BLOCK 1             ; Firing enabled?  Values from TRUE_VALUE/FALSE_VALUE

shot_count:                                 BLOCK 1             ; Count of shots fired (just 8 bits worth), used to index saucer value and direction
