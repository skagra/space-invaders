_ALIEN_MISSILE_OFFSET_COORDS:                           EQU 0
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0:                 EQU 2
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_1:                 EQU 4
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_2:                 EQU 6
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_3:                 EQU 8
_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT:                  EQU 10
_ALIEN_MISSILE_OFFSET_STATE:                            EQU 11
_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN:             EQU 12
_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT:                EQU 13
_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX:                EQU 14 
_ALIEN_MISSILE_STRUCT_SIZE:                             EQU 15


_ALIEN_MISSILE_STATE_NOT_ACTIVE:                        EQU 0b00000001
_ALIEN_MISSILE_STATE_ACTIVE:                            EQU 0b00000010
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN:          EQU 0b00000100    
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN:               EQU 0b00001000
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN:          EQU 0b00010000

_ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT:                    EQU 0
_ALIEN_MISSILE_STATE_ACTIVE_BIT:                        EQU 1
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT:      EQU 2    
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_BIT:           EQU 3
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT:      EQU 4

; Values to give offsets into missile struct
_ALIEN_MISSILE_VARIANT_0:                               EQU 0
_ALIEN_MISSILE_VARIANT_1:                               EQU 1
_ALIEN_MISSILE_VARIANT_2:                               EQU 2
_ALIEN_MISSILE_VARIANT_3:                               EQU 3
_ALIEN_MISSILE_VARIANT_COUNT:                           EQU 4

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
_ALIEN_MISSILE_TYPE_0:                                  EQU 0           
                                              
_ALIEN_MISSILE_TYPE_1:                                  EQU 2              
                                            
_ALIEN_MISSILE_TYPE_2:                                  EQU 4               

_ALIEN_MISSILE_TYPE_COUNT:                              EQU 3

_ALIEN_MISSILE_LOOKUP: WORD _ALIEN_MISSILE_0, _ALIEN_MISSILE_1, _ALIEN_MISSILE_2

_ALIEN_MISSILE_DELTA_Y:                                 EQU 3

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
    JR NZ,.draw_missile

    BIT _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT,A
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
    LD HL,(IX+_ALIEN_MISSILE_OFFSET_COORDS)             ; Current coords
    LD DE,0x0004                                        ; Move missile 4 pixels down 
    ADD HL,DE                                           ; TODO - This should change to 5 when there are 5 or fewer aliens
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

    ; Have we hit the bottom of the screen
    LD A,L                                              ; Y coord
    CP .ALIEN_MISSILE_MAX_Y
    JR C, .update_variant                               ; Still further to travel

    ; The missile has hit the bottom of the screen
    LD A,_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    JR .done

.update_variant:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)
    INC A
    CP A,_ALIEN_MISSILE_VARIANT_COUNT
    JR NZ,.next_variant
    LD A,_ALIEN_MISSILE_VARIANT_0

.next_variant:
    LD (IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT),A
    JR .done

.reached_bottom_of_screen:
    LD A,_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A
    LD A,.ALIEN_MISSILE_EXPLOSION_CYCLES
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),A

    JR .done
    
.at_bottom_of_screen:
    LD A,(IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN)
    DEC A
    LD (IX+_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN),A
    JR NZ,.done

    LD A,_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    JR .done
    
.done_at_bottom_of_screen:
    LD A,_ALIEN_MISSILE_STATE_NOT_ACTIVE
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    LD A,0x00
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A

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

    MACRO GET_RELOAD_STEP_COUNT type,dest
        LD IY,_ALIEN_MISSILE_type
        LD A,(IY+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT)
        LD (alien_missile_offset_reload_dest),A
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
    ; LD A,(alien_missile_offset_reload_0)
    ; LD HL,alien_missile_offset_reload_1
    ; OR (HL)
    ; JR Z,.fire                                        ; Both other reload step counts are zero => fire 

    ; JR .done
.fire
    ; Which column to fire from?
    LD HL,(alien_missile_shot_col_table_ptr)
    LD D,0x00
    LD E,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)
    ADD HL,DE
    LD A,(HL)      
    NOP                                              
    ; LOGPOINT [ALIEN_MISSILES] Selected column is ${A}

    ; Find the lowest alien in the selected column
    LD L,A
    PUSH HL                                             ; Target column (low byte)
    PUSH HL                                             ; Space for the return pointer to alien struct
    CALL alien_pack.get_lowest_active_alien_in_column
    POP HL                                              ; Lowest alien (unless column is empty)
    POP DE

    LD A,H                                              ; High byte == 0 => not found
    CP 0x00
    JR Z,.done

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE), _ALIEN_MISSILE_STATE_ACTIVE    ; Activate the alien missile
    LD IY,HL                                                            ; Alien pointer
    LD HL,(IY+alien_pack._STATE_OFFSET_DRAW_COORDS)
    LD D,0x04
    LD E,0x08
    ADD HL,DE
    LD (IX+_ALIEN_MISSILE_OFFSET_COORDS),HL

.done
    LD A,(IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX)
    INC A                                                   
    CP SHOT_COLUMNS_COUNT
    JR NZ,.dont_reset
    LD A,0x00

.dont_reset
    LD (IX+_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX),A

    POP IY,IX,HL,DE,BC,AF

    RET

alien_missile_offset_reload_0: BLOCK 1
alien_missile_offset_reload_1: BLOCK 1
alien_missile_shot_col_table_ptr: BLOCK 2

SHOT_COLUMNS_0: BYTE 0x00,0x06,0x00,0x00,0x00,0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07
SHOT_COLUMNS_1: BYTE 0x03,0x0A,0x00,0x05,0x02,0x00,0x00,0x0A,0x08,0x01,0x07,0x01,0x0A,0x03,0x06,0x09
SHOT_COLUMNS_2: BYTE 0x05,0x02,0x05,0x04,0x06,0x07,0x08,0x0A,0x06,0x0A,0x03,0x04,0x06,0x07,0x04,0x06     
SHOT_COLUMNS_COUNT: EQU 16

