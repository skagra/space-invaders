;------------------------------------------------------------------------------
;
; Update the state of the current alien missile
; 
; Usage:
;   CALL update
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

update:
    PUSH AF,DE,HL,IX

    LD A,(_enabled)
    BIT utils.TRUE_BIT,A
    JP Z,.done

    LD IX,(_current_alien_missile_ptr)                      ; Point IX to current missile struct

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)                   ; Get the missile state

    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,A               ; Not active?
    JR NZ,.not_active                                       ; Handle it

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A                   ; Active?
    JR NZ,.active                                           ; Handle it.

    BIT _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT,A ; Reached bottom of screen?
    JR NZ,.reached_bottom_of_screen                         ; Handle it.

    BIT _ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_BIT,A      ; At bottom of screen?
    JR NZ,.at_bottom_of_screen                              ; Handle it.

    BIT _ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT,A ; Done exploding bottom of screen?
    JR NZ,.done_at_bottom_of_screen                         ; Handle it.

    BIT _ALIEN_MISSILE_STATE_HIT_SHIELD_BIT,A               ; Hit a shield?
    JR NZ,.hit_shield                                       ; Handle it.

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JR .done

.not_active:
    CALL _fire_if_ready                                     ; Fire a new missile if it's time to do so
    JR .done

.active:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT)       ; Record that the missile has taken a step
    INC A                                                
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A

    LD HL,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Current coords
    LD A,(_missile_delta)                                   ; Move missile down the screen 
    ADD L
    LD L,A
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

    ; Have we hit the bottom of the screen
    LD A,L                                                  ; Y coord
    CP layout.ALIEN_MISSILE_MAX_Y
    JR C, .update_variant                                   ; Still further to travel

    ; The missile has hit the bottom of the screen
    LD A,_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_VALUE ; Update state to indicate missile has reached the bottom of the screen
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    JR .done

.update_variant:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)         ; Move on to the next sprite variant
    INC A
    CP A,_ALIEN_MISSILE_VARIANT_COUNT
    JR NZ,.next_variant
    LD A,_ALIEN_MISSILE_VARIANT_0

.next_variant:    
    LD (IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT),A
    
    JR .done

.reached_bottom_of_screen:                                  ; Reached the bottom of the screen
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_VALUE
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),.ALIEN_MISSILE_EXPLOSION_CYCLES

    JR .done
    
.at_bottom_of_screen:                                       ; Exploding at the bottom of the screen
    LD A,(IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN)    ; One more explosion cycle completed
    DEC A
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),A    ; Finished exploding?
    JR NZ,.done                                             ; No

    LD A,_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_VALUE ; Yes - finished exploding
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A                   ; Set state

    JR .done
    
.done_at_bottom_of_screen:                                  ; Finished exploding at bottom of screen
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE ; State
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),0       ; Reset step count used as part of reload algorithm

    JR .done

.hit_shield
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE ; Move it to a not active state
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),0       ; Reset step count used as part of reload algorithm

    JR .done

.done:
    POP IX,HL,DE,AF

    RET

.ALIEN_MISSILE_EXPLOSION_CYCLES: EQU 3                      ; How long to display a missile explosion

;------------------------------------------------------------------------------
;
; Move onto the next missile type
; 
; Usage:
;   CALL next
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

next:
    PUSH AF,DE,HL,IX

    LD IX,(_current_alien_missile_ptr)
    LD A,(IX+_ALIEN_MISSILE_OFFSET_TYPE)                     ; Get the current alien type

    CP _ALIEN_MISSILE_TYPE_0                                ; Type 0?
    JR Z,.type_0                                            ; Handle it.

    CP _ALIEN_MISSILE_TYPE_1                                ; Type 1?
    JR Z,.type_1                                            ; Handle it.

    ; type 2
    LD DE,_ALIEN_MISSILE_0
    JR .set_type

.type_0:
    LD DE,_ALIEN_MISSILE_1
    JR .set_type

.type_1:
    LD DE,_ALIEN_MISSILE_2
    JR .set_type

.set_type:
    LD HL,_current_alien_missile_ptr
    LD (HL),DE

    POP IX,DE,HL,AF

    RET

    MACRO GET_RELOAD_STEP_COUNT alien_num,stash
        LD IY,_ALIEN_MISSILE_alien_num
        LD A,(IY+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT)  
        LD (.alien_missile_step_count_stash),A                   
    ENDM

;------------------------------------------------------------------------------
;
; Fire a new missile if its time
; 
; Usage:
;   CALL _fire_if_ready
;
; Firing algorithm
;
; Is there an alien in the currently selected column?
;   yes => continue
;   no => update to next value in column lookup table and done
;
; Are both of the other step counts zero?
; or 
; Is the lowest non zero of the other two step counts > reload threshold?
;   yes => fire and update to next value in column lookup table
;   no => done
;
;------------------------------------------------------------------------------

_fire_if_ready:
    PUSH AF,BC,DE,HL,IX,IY

    ; Point IX to current missile struct
    LD IX,(_current_alien_missile_ptr)                      

    ; Get the step count of the other two missiles
    LD A,(IX+_ALIEN_MISSILE_OFFSET_TYPE)  

    CP _ALIEN_MISSILE_TYPE_0
    JR Z,.type_0

    CP _ALIEN_MISSILE_TYPE_1
    JR Z,.type_1

    ; type 2  
    GET_RELOAD_STEP_COUNT 0,0
    GET_RELOAD_STEP_COUNT 1,1

    JR .fire_test

.type_0:
    GET_RELOAD_STEP_COUNT 1,0
    GET_RELOAD_STEP_COUNT 2,1

    LD DE,.SHOT_COLUMNS_0
    LD HL,.alien_missile_shot_col_table_ptr
    LD (HL),DE

    JR .fire_test

.type_1:
    LD A,(_missile_1_enabled)
    BIT utils.TRUE_BIT,A
    JP Z,.done

    GET_RELOAD_STEP_COUNT 0,0
    GET_RELOAD_STEP_COUNT 2,1

    LD DE,.SHOT_COLUMNS_1
    LD HL,.alien_missile_shot_col_table_ptr
    LD (HL),DE

    JR .fire_test

.fire_test
    ; LOGPOINT [ALIEN_MISSILES] fire_test --->
    ; LOGPOINT [ALIEN_MISSILES] alien_missile_step_count_0=${(alien_missiles.alien_missile_step_count_0)}
    ; LOGPOINT [ALIEN_MISSILES] alien_missile_step_count_1=${(alien_missiles.alien_missile_step_count_1)}

    ; Test whether both reload step counts are zero
    LD A,(.alien_missile_step_count_0)
    LD B,A
    LD A,(.alien_missile_step_count_1)
    OR B
    JR Z,.fire                                              ; Both reload step counts are zero => fire 

    ; Use the lowest of the two - ignoring zero values
    LD A,(.alien_missile_step_count_0)                      ; Is reload_0 zero?
    CP 0x00
    JR Z,.step_count_0_is_zero

    LD A,(.alien_missile_step_count_1)                      ; Is reload_1 zero?
    CP 0x00
    JR Z,.step_count_1_is_zero

    ; Both are non-zero so find the lowest
    LD A,(.alien_missile_step_count_0) 
    LD B,A
    LD A,(.alien_missile_step_count_1)
    CP B

    JR C, .step_count_1_is_lower 

    LD A,(.alien_missile_step_count_0)                      ; LOGPOINT [ALIEN_MISSILES] step_count_0_is_lower
    JR .test_reload_threshold

.step_count_1_is_lower:
    LD A,(.alien_missile_step_count_1)                      ; LOGPOINT [ALIEN_MISSILES] step_count_1_is_lower
    JR .test_reload_threshold

.step_count_0_is_zero:
    ; Reload 1 must be non-zero as we've already tested for both being zero.
    LD A,(.alien_missile_step_count_1)                      ; LOGPOINT [ALIEN_MISSILES] step_count_0_is_zero
    JR .test_reload_threshold

.step_count_1_is_zero:
    ; Reload 0 must be non-zero as we've already tested for both being zero.
    LD A,(.alien_missile_step_count_0)                      ; LOGPOINT [ALIEN_MISSILES] step_count_1_is_zero
    JR .test_reload_threshold

.test_reload_threshold:                                      
    LD B,A
    LD A,(_reload_rate)                                     
    CP B                                                    ; LOGPOINT [ALIEN_MISSILES] Testing step count ${B} against threshold ${A}       
    JR NC,.done 

.fire
    LD A,(IX+_ALIEN_MISSILE_OFFSET_TYPE)
    CP _ALIEN_MISSILE_TYPE_2
    JP Z,.target_missile_type_2

    ; Which column to fire from?
    LD HL,(.alien_missile_shot_col_table_ptr)               ; LOGPOINT [ALIEN_MISSILES] Firing
    LD D,0x00
    LD E,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)
    ADD HL,DE
    LD A,(HL)                                            

    ; Find the lowest alien in the selected column
    LD L,A
    PUSH HL                                                 ; Target column (low byte)
    PUSH HL                                                 ; Space for the return pointer to alien struct
    CALL aliens.get_lowest_active_alien_in_column
    POP HL                                                  ; Lowest alien (unless column is empty)
    POP DE

    LD A,H                                                  ; High byte == 0 => not found
    CP 0x00
    JR Z,.update_to_next_col
    JR .firing_alien_found

.target_missile_type_2:                                     ; Type 1 missile directly targets the player
    LD A,(_seeker_missile_toggle)                           ; Fires only every other time it is eligible
    XOR 0x01
    LD (_seeker_missile_toggle),A
    JR Z,.done

    LD A,(player.player_x)                                  ; X coord of player base
    LD H,A                                 
    LD L,0x00 
    PUSH HL

    PUSH HL                                                 ; Space for the return value

    CALL aliens.get_lowest_alien_at_x
    
    POP HL                                                  ; Return value
    POP DE

    LD A,H                                                  ; 0xFF in high byte => no match
    CP H,0xFF
    JR Z,.done
    ; Fall through

.firing_alien_found
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE), _ALIEN_MISSILE_STATE_ACTIVE_VALUE ; Activate the missile
    LD IY,HL                                                ; Alien pointer
    LD HL,(IY+aliens.STATE_OFFSET_DRAW_COORDS)              ; Alien coords
    LD DE,layout.ALIEN_MISSILE_OFFSET_COORDS                ; Adjust firing coords to bottom middle of alien
    ADD HL,DE
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),0x01    ; One step taken (required for reload algorithm)
    ; Fall through to update_to_next_col

.update_to_next_col:                                        ; TODO Don't need to do this for type 2 missile (as targetted at player)
    LD A,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)       ; Update location in column table,
    INC A                                                   ; if either we've fired or there were no aliens in the selected column
    CP .SHOT_COLUMNS_COUNT                                  ; Has the end of the column lookup table been reached?
    JR NZ,.dont_reset_col_lookup                            ; No - so we are good
    LD A,0x00                                               ; Yes - reset to the start

.dont_reset_col_lookup:
    LD (IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX),A       ; Store the new location in column lookup table

.done:
    POP IY,IX,HL,DE,BC,AF

    ; LOGPOINT [ALIEN_MISSILES] <--- fire_test

    RET

; Tables of alien columns from which to launch missiles
.SHOT_COLUMNS_0: BYTE 0x00,0x06,0x00,0x00,0x00,0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07
.SHOT_COLUMNS_1: BYTE 0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07,0x01,0x0A,0x03,0x06,0x09
.SHOT_COLUMNS_COUNT: EQU 16

.alien_missile_shot_col_table_ptr:  BLOCK 2                 ; Shot column table for the current alien missiles
.alien_missile_step_count_0:        BLOCK 1                 ; Step count for one of the "other" two alien missiles
.alien_missile_step_count_1:        BLOCK 1                 ; Step count for the other of the "other" two alien missiles
