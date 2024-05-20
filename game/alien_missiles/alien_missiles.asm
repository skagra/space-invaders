; Offsets into the alien missile struct
_ALIEN_MISSILE_OFFSET_COORDS:                           EQU 0                   ; Coordinates
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0:                 EQU 2                   ; First sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_1:                 EQU 4                   ; Second sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_2:                 EQU 6                   ; Third sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_3:                 EQU 8                   ; Fourth sprite variant
_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT:                  EQU 10                  ; Current variant (from _ALIEN_MISSILE_VARIANT_?)
_ALIEN_MISSILE_OFFSET_STATE:                            EQU 11                  ; State (from _ALIEN_MISSILE_STATE_*)
_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN:             EQU 12                  ; Count down when the missile is exploding at the bottom of the screen
_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT:                EQU 13                  ; Number of active steps taken - used as part of the reload algorithm
_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX:                EQU 14                  ; Index into relevant SHOT_COLUMNS_? table for the next column to fire
_ALIEN_MISSILE_STRUCT_SIZE:                             EQU 15                  ; Size of the entire struct in bytes


; Alien missile states
_ALIEN_MISSILE_STATE_NOT_ACTIVE:                        EQU 0b00000001          ; The missile is not active
_ALIEN_MISSILE_STATE_ACTIVE:                            EQU 0b00000010          ; Moving down the screen
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN:          EQU 0b00000100          ; Reach the bottom of the screen
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN:               EQU 0b00001000          ; At the bottom of the screen and so exploding
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN:          EQU 0b00010000          ; Finised exploding

; Bit positions correspond to each of the states
_ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT:                    EQU 0
_ALIEN_MISSILE_STATE_ACTIVE_BIT:                        EQU 1
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT:      EQU 2    
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_BIT:           EQU 3
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT:      EQU 4

; Values to indicate current missile sprite variant
_ALIEN_MISSILE_VARIANT_0:                               EQU 0
_ALIEN_MISSILE_VARIANT_1:                               EQU 1
_ALIEN_MISSILE_VARIANT_2:                               EQU 2
_ALIEN_MISSILE_VARIANT_3:                               EQU 3
_ALIEN_MISSILE_VARIANT_COUNT:                           EQU 4

; Three alien missiles
_ALIEN_MISSILE_0: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_0_VARIANT_0,sprites.ALIEN_MISSILE_0_VARIANT_1,sprites.ALIEN_MISSILE_0_VARIANT_2,sprites.ALIEN_MISSILE_0_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE,0x00,0x00,0x00
_ALIEN_MISSILE_1: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_1_VARIANT_0,sprites.ALIEN_MISSILE_1_VARIANT_1,sprites.ALIEN_MISSILE_1_VARIANT_2,sprites.ALIEN_MISSILE_1_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE,0x00,0x00,0x00
_ALIEN_MISSILE_2: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_2_VARIANT_0,sprites.ALIEN_MISSILE_2_VARIANT_1,sprites.ALIEN_MISSILE_2_VARIANT_2,sprites.ALIEN_MISSILE_2_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE,0x00,0x00,0x00

; Values set to give offsets into _ALIEN_MISSILE_LOOKUP table 
; TODO Not convinced this is either good or necessary
_ALIEN_MISSILE_TYPE_0:                                  EQU 0           
                                              
_ALIEN_MISSILE_TYPE_1:                                  EQU 2              
                                            
_ALIEN_MISSILE_TYPE_2:                                  EQU 4               

_ALIEN_MISSILE_TYPE_COUNT:                              EQU 3

; Lookup table from type to corresponding struct
_ALIEN_MISSILE_LOOKUP: WORD _ALIEN_MISSILE_0, _ALIEN_MISSILE_1, _ALIEN_MISSILE_2

; Nominal number of pixels to move a missile each cycle
_ALIEN_MISSILE_DELTA_Y:                                 EQU 3

; Current alient missile type with values from _ALIEN_MISSILE_TYPE_?
_current_alien_missile_type: BLOCK 1

init:
    PUSH AF

    LD A,_ALIEN_MISSILE_TYPE_0
    LD (_current_alien_missile_type),A

    POP AF

    RET

draw:
    PUSH DE,HL,IX

     ; Point IX to current missle struct
    LD DE,_ALIEN_MISSILE_LOOKUP                         ; Base of alient lookup table
    LD A,(_current_alien_missile_type)                  ; Current type of missle TODO - This missile type might be less than ideal - could just hold the address and do without all of this
    LD H,0x00                                           
    LD L,A
    ADD HL,DE                                           ; Add base to missle type to give location of address of current alient struct
    LD DE,(HL)                                          ; Address of current alient struct => DE
    LD IX,0x0000                                        ; Transfer into IX
    ADD IX,DE

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)               ; Current missile state

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A               ; Active? Draw the missle.
    JR NZ,.draw_missile

    BIT _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT,A ; Reached the bottom of the screen? Draw the missile exploding.
    JR NZ,.draw_explosion

    JR .done

.draw_missile:
    ; Draw the current alien missile
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Coords
    PUSH DE
    
    LD DE,sprites.ALIEN_MISSILE_0_VARIANT_0_DIMS        ; Dimensions - TODO This should really be pulled from the actual variant!
    PUSH DE

    ; Which variant are we dealing with?                ; Sprite/mask
    LD D,0x00                                           ; Current alient type 0 to 3
    LD E,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)
    SLA E                                               ; Double it - as there are WORDs in the table
    LD HL,_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0        ; Add on the offset for the first variant
    ADD HL,DE                                           ; HL now contains the offset of the address of the variant (offset from IX)
    LD DE,IX                                            ; Offset from the base address
    ADD HL,DE
    LD DE,(HL)
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing (not blanking)
    PUSH DE 

    CALL draw.draw_sprite                               ; Draw the bullet
   
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.draw_explosion:
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Coords
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION_DIMS          ; Dimensions
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION               ; Spite/mask
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing (not blanking)
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the explosion
   
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP IX,HL,DE

    RET

blank:
    PUSH AF,DE,HL,IX

    ; Point IX to current missle struct
    LD DE,_ALIEN_MISSILE_LOOKUP  
    LD A,(_current_alien_missile_type)  
    LD H,0x00  
    LD L,A
    ADD HL,DE
    LD DE,(HL)
    LD IX,0x0000
    ADD IX,DE

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.blank_missile

    BIT _ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT,A
    JR NZ,.blank_explosion

    JR .done

.blank_missile:
    ; Draw the current alien missile
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Coords
    PUSH DE
    
    LD DE,sprites.ALIEN_MISSILE_0_VARIANT_0_DIMS        ; Dimensions - TODO This should really be pulled from the actual variant!
    PUSH DE

    ; Which variant are we dealing with?                ; Sprite/mask
    LD D,0x00                                           ; Current alient type 0 to 3
    LD E,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)
    SLA E                                               ; Double it - as there are WORDs in the table
    LD HL,_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0        ; Add on the offset for the first variant
    ADD HL,DE                                           ; HL now contains the offset of the address of the variant (offset from IX)
    LD DE,IX                                            ; Offset from the base address
    ADD HL,DE
    LD DE,(HL)
    PUSH DE 

    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE 

    CALL draw.draw_sprite                               ; Draw the bullet
   
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.blank_explosion:
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Coords
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION_DIMS          ; Dimensions
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION               ; Spite/mask
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE

    CALL draw.draw_sprite                               ; Blank the explosion
   
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP IX,HL,DE,AF

    RET

update:
    PUSH AF,DE,HL,IX

    ; Point IX to current missle struct
    LD DE,_ALIEN_MISSILE_LOOKUP  
    LD A,(_current_alien_missile_type)  
    LD H,0x00  
    LD L,A
    ADD HL,DE
    LD DE,(HL)
    LD IX,0x0000
    ADD IX,DE

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)

    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,A
    JR NZ,.not_active

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.active

    BIT _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT,A
    JR NZ,.reached_bottom_of_screen

    BIT _ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_BIT,A
    JR NZ,.at_bottom_of_screen

    BIT _ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT,A
    JR NZ,.done_at_bottom_of_screen

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JR .done

.not_active:
    CALL _fire_if_ready
    JR .done

.active:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT)   
    INC A                                                
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A

    LD HL,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Current coords
    LD DE,0x0004                                        ; Move missile 4 pixels down 
    ADD HL,DE                                           ; TODO - This should change to 5 when there are 5 or fewer aliens
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

    ; Have we hit the bottom of the screen
    LD A,L                                              ; Y coord
    CP .ALIEN_MISSILE_MAX_Y
    JR C, .update_variant                               ; Still further to travel

    ; The missile has hit the bottom of the screen
    LD A,_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN  ; Update state to indicate missile has reached the bottom of the screen
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    JR .done

.update_variant:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)     ; Move on to the next sprite variant
    INC A
    CP A,_ALIEN_MISSILE_VARIANT_COUNT
    JR NZ,.next_variant
    LD A,_ALIEN_MISSILE_VARIANT_0

.next_variant:    
    LD (IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT),A
    
    JR .done

.reached_bottom_of_screen:                                  ; Reached the bottom of the screen
    LD A,_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN           ; Set state 
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A
    LD A,.ALIEN_MISSILE_EXPLOSION_CYCLES                    ; Set counter for explosion cycles
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),A

    JR .done
    
.at_bottom_of_screen:                                       ; Exploding at the bottom of the screen
    LD A,(IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN)    ; One more explosion cycle completed
    DEC A
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),A    ; Finished exploding?
    JR NZ,.done                                             ; No

    LD A,_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN      ; Yes - finished exploding
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A                   ; Set state

    JR .done
    
.done_at_bottom_of_screen:                                  ; Finished exploding at bottom of screen
    LD A,_ALIEN_MISSILE_STATE_NOT_ACTIVE
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A                   ; State

    LD A,0x00
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A       ; Reset step count used as part of reload algorithm

    JR .done
    
.done:
    POP IX,HL,DE,AF

    RET

.ALIEN_MISSILE_MAX_Y:            EQU draw_common.SCREEN_HEIGHT_PIXELS-20
.ALIEN_MISSILE_EXPLOSION_CYCLES: EQU 3

next:
    PUSH AF

    LD A,(_current_alien_missile_type)  
    CP _ALIEN_MISSILE_TYPE_0
    JR Z,.type_0

    CP _ALIEN_MISSILE_TYPE_1
    JR Z,.type_1

    ; type 2
    LD A,_ALIEN_MISSILE_TYPE_0
    JR .set_type

.type_0:
    LD A,_ALIEN_MISSILE_TYPE_1
    JR .set_type

.type_1:
    LD A,_ALIEN_MISSILE_TYPE_2
    JR .set_type

.set_type:
    LD (_current_alien_missile_type),A

    POP AF

    RET

    MACRO GET_RELOAD_STEP_COUNT alien_num,stash
        LD IY,_ALIEN_MISSILE_alien_num
        LD A,(IY+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT)  
        LD (alien_missile_step_count_stash),A                   
    ENDM

_fire_if_ready:
    PUSH AF,BC,DE,HL,IX,IY

    ; Point IX to current missle struct
    LD DE,_ALIEN_MISSILE_LOOKUP  
    LD A,(_current_alien_missile_type)  
    LD H,0x00  
    LD L,A
    ADD HL,DE
    LD DE,(HL)
    LD IX,0x0000
    ADD IX,DE

    ; Get the step count of the other two missiles
    LD A,(_current_alien_missile_type)  
    CP _ALIEN_MISSILE_TYPE_0
    JR Z,.type_0

    CP _ALIEN_MISSILE_TYPE_1
    JR Z,.type_1

    ; type 2  
    GET_RELOAD_STEP_COUNT 0,0
    GET_RELOAD_STEP_COUNT 1,1

    LD DE,SHOT_COLUMNS_2
    LD HL,alien_missile_shot_col_table_ptr
    LD (HL),DE

    JR .fire_test

.type_0:
    GET_RELOAD_STEP_COUNT 1,0
    GET_RELOAD_STEP_COUNT 2,1

    LD DE,SHOT_COLUMNS_0
    LD HL,alien_missile_shot_col_table_ptr
    LD (HL),DE

    JR .fire_test

.type_1:
    GET_RELOAD_STEP_COUNT 0,0
    GET_RELOAD_STEP_COUNT 2,1

    LD DE,SHOT_COLUMNS_1
    LD HL,alien_missile_shot_col_table_ptr
    LD (HL),DE

    JR .fire_test

.fire_test
    ; LOGPOINT [ALIEN_MISSILES] --->
    ; LOGPOINT [ALIEN_MISSILES] alien_missile_step_count_0=${(alien_missiles.alien_missile_step_count_0)}
    ; LOGPOINT [ALIEN_MISSILES] alien_missile_step_count_1=${(alien_missiles.alien_missile_step_count_1)}

    ; Test whether both reload step counts are zero
    LD A,(alien_missile_step_count_0)
    LD B,A
    LD A,(alien_missile_step_count_1)
    OR B
    JR Z,.fire                                          ; Both reload step counts are zero => fire 

    ; Use the lowest of the two - ignoring zero values
    LD A,(alien_missile_step_count_0)                   ; Is reload_0 zero?
    CP 0x00
    JR Z,.step_count_0_is_zero

    LD A,(alien_missile_step_count_1)                   ; Is reload_1 zero?
    CP 0x00
    JR Z,.step_count_1_is_zero

    ; Both are non-zero so find the lowest
    LD A,(alien_missile_step_count_0) 
    LD B,A
    LD A,(alien_missile_step_count_1)
    CP B

    JR C, .step_count_1_is_lower 

    LD A,(alien_missile_step_count_0)                   ; LOGPOINT [ALIEN_MISSILES] step_count_0_is_lower
    JR .test_reload_threshold

.step_count_1_is_lower:
    LD A,(alien_missile_step_count_1)                   ; LOGPOINT [ALIEN_MISSILES] step_count_1_is_lower
    JR .test_reload_threshold

.step_count_0_is_zero:
    ; Reload 1 must be non-zero as we've already tested for both being zero.
    LD A,(alien_missile_step_count_1)                   ; LOGPOINT [ALIEN_MISSILES] step_count_0_is_zero
    JR .test_reload_threshold

.step_count_1_is_zero:
    ; Reload 0 must be non-zero as we've already tested for both being zero.
    LD A,(alien_missile_step_count_0)                   ; LOGPOINT [ALIEN_MISSILES] step_count_1_is_zero
    JR .test_reload_threshold

.test_reload_threshold                                  ; TODO this will become variable reload rate
    LD B,14                                             ; LOGPOINT [ALIEN_MISSILES] Testing step count ${A} against threshold 14
    CP B                                                
    JR C,.done                                          ; Not time to reload yet

.fire
    ; Which column to fire from?
    LD HL,(alien_missile_shot_col_table_ptr)            ; LOGPOINT [ALIEN_MISSILES] Firing
    LD D,0x00
    LD E,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)
    ADD HL,DE
    LD A,(HL)                                            
                                           
    ; Find the lowest alien in the selected column
    LD L,A
    PUSH HL                                             ; Target column (low byte)
    PUSH HL                                             ; Space for the return pointer to alien struct
    CALL alien_pack.get_lowest_active_alien_in_column
    POP HL                                              ; Lowest alien (unless column is empty)
    POP DE

    LD A,H                                              ; High byte == 0 => not found
    CP 0x00
    JR Z,.update_to_next_col

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE), _ALIEN_MISSILE_STATE_ACTIVE    ; Activate the missile
    LD IY,HL                                            ; Alien pointer
    LD HL,(IY+alien_pack._STATE_OFFSET_DRAW_COORDS)     ; Alien coords
    LD D,0x04                                           ; Adjust firing coords to bottom middle of alien
    LD E,0x08
    ADD HL,DE
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),0x01 ; One step taken (required for reload algorithm)
    ; Fall through 

.update_to_next_col:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)   ; Update location in column table,
    INC A                                               ; if either we've fired or there were no aliens in the selected column
    CP SHOT_COLUMNS_COUNT                               ; Has the end of the column lookup table been reached?
    JR NZ,.dont_reset_col_lookup                        ; No - so we are good
    LD A,0x00                                           ; Yes - reset to the start

.dont_reset_col_lookup:
    LD (IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX),A   ; Store the new location in column lookup table

.done:
    POP IY,IX,HL,DE,BC,AF

    ; LOGPOINT [ALIEN_MISSILES] <---

    RET

alien_missile_step_count_0: BLOCK 1
alien_missile_step_count_1: BLOCK 1
alien_missile_shot_col_table_ptr: BLOCK 2

SHOT_COLUMNS_0: BYTE 0x00,0x06,0x00,0x00,0x00,0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07
SHOT_COLUMNS_1: BYTE 0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07,0x01,0x0A,0x03,0x06,0x09
SHOT_COLUMNS_2: BYTE 0x05,0x02,0x05,0x04,0x06,0x07,0x08,0x0A,0x06,0x0A,0x03,0x04,0x06,0x07,0x04,0x06     
SHOT_COLUMNS_COUNT: EQU 16

