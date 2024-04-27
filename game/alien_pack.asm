    MODULE alien_pack

init:
    PUSH AF

    ; Alien pack direction
    LD A,DIRECTION_RIGHT
    LD (direction),A

    LD A,0x10
    LD (pack_x_reference),A

    POP AF

    RET

reset_to_pack_start:
    PUSH HL
    LD HL,aliens                            ; Set pointer to alien definitions to start of the pack
    LD (current_alien_ptr),HL
    POP HL

    RET

;------------------------------------------------------------------------------
;
; Choose a varient of a sprite base on bit 0 of a supplied value
; 
; Usage:
;   PUSH rr  ; Determinant to select sprinte variant
;   PUSH rr  ; Pointer to pointer to the first variant
;   PUSH rr  ; Reserve space for return value
;   CALL select_sprite_variant
;   POP rr   ; Return value pointing to the variant data 
;   POP rr   ; Ditch supplied parameter
;   POP rr   ; Ditch supplied parameter
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

SP_PARAM_DETERMINANT:   EQU 12
SP_PARAM_VARIANT_0_PTR: EQU 10
SP_RTN_OFFSET:          EQU 8

select_sprite_variant:
    PUSH BC,HL,IX

    LD  IX,0                                    ; Point IX to the stack
    ADD IX,SP 

    ; Which variant of sprite to draw?
    LD BC,(IX+SP_PARAM_DETERMINANT)
    BIT 0,C                             
    JR NZ,.variant_1

    ; Variant 0 - the supplied pointer is what we need
    LD HL,(IX+SP_PARAM_VARIANT_0_PTR)
    JR .done

.variant_1:  
    ; Variant 1 - the supplied pointer needs to be increased by 2
    LD BC,(IX+SP_PARAM_VARIANT_0_PTR)  
    LD H,0x0
    LD L,0x2
    ADD HL,BC
    
.done:
    LD BC,(HL)
    LD (IX+SP_RTN_OFFSET),BC

    POP IX,HL,BC

    RET

;------------------------------------------------------------------------------
;
; Erase alien at old coords and draw alien at new coords
; 
; Usage:
;   PUSH rr  ; Old coordinates, X in MSB, Y in LSB
;   PUSH rr  ; New coordinates, Y in MSB, Y in LSB
;   PUSH rr  ; Address of sprite data
;   CALL draw_alien
;   POP rr   ; Ditch supplied parameter 
;   POP rr   ; Ditch supplied parameter
;   POP rr   ; Ditch supplied parameter
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

DA_PARAM_OLD_COORDS:    EQU 10
DA_PARAM_NEW_COORDS:    EQU 8
DA_PARAM_SPRITE_DATA:   EQU 6

draw_alien:
    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP 

    ; Blank old sprite position
    LD DE,(IX+DA_PARAM_OLD_COORDS)          ; Coords
    PUSH DE     
    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE
    LD DE,sprites.sprite_blank              ; Background square
    PUSH DE
    LD DE,sprites.mask_2x16                 ; Mask
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    ; Draw sprite in new position
    LD DE,(IX+DA_PARAM_NEW_COORDS)          ; Coords
    PUSH DE     
    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE
    LD DE,(IX+DA_PARAM_SPRITE_DATA)         ; Sprite data
    PUSH DE
    LD DE,sprites.mask_2x16                 ; Mask
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

;------------------------------------------------------------------------------
;
; Switches direction of alien pack as necessary
; 
; Usage:
;   CALL adjust_alien_pack_direction
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Note: This routing currently makes use of a shared global pack_x_reference
;------------------------------------------------------------------------------
adjust_alien_pack_direction:
    PUSH AF,HL

    ; In which directin is the pack currently moving?
    LD A,(direction)    

    CP DIRECTION_RIGHT
    JR Z,.currently_moving_right

    CP DIRECTION_LEFT
    JR Z,.currently_moving_left

    ; Pack is moving down
    CP DIRECTION_DOWN_AT_RIGHT
    JR Z,.currently_moving_down_at_right

    ; Pack is at left of screen
    LD A,DIRECTION_RIGHT                    ; Switch to moving right
    LD (direction),A

    JR .done

.currently_moving_down_at_right:
    LD A,DIRECTION_LEFT                     ; Switch to moving left
    LD (direction),A

    JR .done

.currently_moving_right:
    ; Pack is moving right
    LD A,(pack_x_reference)                 ; Get the reference X coord
    CP 96
    JR C,.carry_on_right

    ; Swich to moving down
    LD A,DIRECTION_DOWN_AT_RIGHT            ; Switch to moving left
    LD (direction),A
    JR .done

.carry_on_right:
    LD A,(pack_x_reference)
    INC A
    INC A
    LD (pack_x_reference),A

    JR .done

.currently_moving_left:
    ; Pack is moving left
    LD A,(pack_x_reference)                 ; Get the reference X coord
    CP 0x04
    JR NC,.carry_on_left

    ; Swich to moving down
    LD A,DIRECTION_DOWN_AT_LEFT             ; Switch to moving left
    LD (direction),A
    JR .done

.carry_on_left:
    LD A,(pack_x_reference)
    DEC A
    DEC A
    LD (pack_x_reference),A
    JR .done

.done
    POP HL,AF

    RET

move_alien:
    PUSH AF,DE,HL

     ; Move sprite to new position
    LD HL,(current_alien_ptr)               ; Current alien
    LD DE,(HL)                              ; Coords are at start of alien definition

    ; Are we moving left, right or down
    LD A,(direction)
    CP DIRECTION_LEFT
    JR NZ,.not_moving_left

    ; Moving left
    DEC D
    DEC D
    LD (main.current_alien_new_coords),DE  ; TODO: These need to be pushed

    JR .done_moving

.not_moving_left:
    CP DIRECTION_RIGHT
    JR NZ,.moving_down

    ; Moving right
    INC D
    INC D
    LD (main.current_alien_new_coords),DE

    JR .done_moving

.moving_down:
    ; Moving down
    LD A,8
    ADD A,E
    LD E,A
    LD (main.current_alien_new_coords),DE

.done_moving:
    POP HL,DE,AF

    RET

aliens:         
    WORD 0x1060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
    WORD 0x6060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

    WORD 0x1050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
    WORD 0x6050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

    WORD 0x1040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
    WORD 0x6040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

    WORD 0x1030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
    WORD 0x6030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

    WORD 0x1020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x2020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x3020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x4020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x5020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1
    WORD 0x6020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x7020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x8020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x9020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0xA020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1

ALIEN_PACK_SIZE:            EQU ($-aliens)/6

current_alien_ptr:          BLOCK 2

pack_x_reference:           BLOCK 1

direction:                  BLOCK 1

; TODO: Maybe change this to bit numbers and a mask for efficiency
DIRECTION_LEFT:             EQU 1   
DIRECTION_RIGHT:            EQU 2
DIRECTION_DOWN_AT_LEFT:     EQU 3
DIRECTION_DOWN_AT_RIGHT:    EQU 4


    ENDMODULE
