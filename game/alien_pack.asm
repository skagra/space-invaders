    MODULE alien_pack

; TODO: Change these to bit numbers and a mask for efficiency
_PACK_DIRECTION_LEFT:              EQU 1   
_PACK_DIRECTION_RIGHT:             EQU 2
_PACK_DIRECTION_DOWN_AT_LEFT:      EQU 3
_PACK_DIRECTION_DOWN_AT_RIGHT:     EQU 4

_current_alien_ptr:                BLOCK 2
_current_pack_variant_flag:        BLOCK 1
_current_alien_sprite_ptr          BLOCK 2      ; The variant we are about to draw
_old_alien_sprite_ptr:             BLOCK 2      ; The variant used last time - use as a mask for erasure
_current_alien_new_coords:         BLOCK 2

_pack_x_reference:                 BLOCK 1
_pack_direction:                   BLOCK 1

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
    PUSH AF,HL

    ; Alien pack direction
    LD A,_PACK_DIRECTION_RIGHT
    LD (_pack_direction),A

    ; Reference pack X coord
    LD A,0x10                               ; TODO
    LD (_pack_x_reference),A

    ; Pack variant
    LD A,0x01
    LD (_current_pack_variant_flag),A

    ; Pointer to pack data
    LD HL,_aliens                            
    LD (_current_alien_ptr),HL

    POP HL,AF

    RET

;------------------------------------------------------------------------------
;
; Choose a varient of a sprite based on 
; 
; Usage:
;   CALL select_sprite_variant _current_pack_variant_flag
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

_select_sprite_variant:
    PUSH BC,HL

    ; Get a pointer to pointer to first sprite variant
    LD HL,(_current_alien_ptr)
    INC HL
    INC HL

    ; Which variant of sprite to draw?
    LD A,(_current_pack_variant_flag)
    BIT 0,A                            
    JR NZ,.variant_1

    ; Variant 0 -  pointer is what we need
    LD BC,(HL)
    LD (_current_alien_sprite_ptr),BC

    INC HL;
    INC HL
    LD BC,(HL)
    LD (_old_alien_sprite_ptr),BC

    JR .done

.variant_1:  
    ; Variant 1 - pointer needs to be increased by 2
    LD BC,(HL)
    LD (_old_alien_sprite_ptr),BC

    INC HL;
    INC HL
    LD BC,(HL)
    LD (_current_alien_sprite_ptr),BC
    
.done:
    POP HL,BC

    RET

;------------------------------------------------------------------------------
;
; Erase alien at old coords and draw alien at new coords
; 
; Usage:
;
;   CALL draw_alien
;
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

blank_current_alien:
    PUSH DE,HL

    ; Blank old sprite position
    LD HL,(_current_alien_ptr)              ; Coords
    LD DE,(HL)                                     
    PUSH DE     

    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_2b_x_8px     ; Background square
    PUSH DE

    ; LD DE,sprites.mask_2x8                  ; Mask 
    LD HL,(_old_alien_sprite_ptr) ; Use sprite as mask here so as to not overwrite what we shouldn't
    PUSH HL

    CALL draw.draw_sprite

    POP DE
    POP DE
    POP DE
    POP DE

    POP HL,DE

    RET

draw_current_alien:
    PUSH DE,HL

    ; Draw sprite in new position
    LD DE,(_current_alien_new_coords)       ; Coords
    PUSH DE

    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE

    LD DE,(_current_alien_sprite_ptr)       ; Sprite data
    PUSH DE

    ; LD DE,sprites.mask_2x8                  ; Mask
    PUSH DE

    CALL draw.draw_sprite

    POP DE
    POP DE
    POP DE
    POP DE

    POP HL,DE

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
;------------------------------------------------------------------------------

_adjust_alien_pack_direction:
    PUSH AF,HL

    ; In which directin is the pack currently moving?
    LD A,(_pack_direction)    

    ; Moving right?
    CP _PACK_DIRECTION_RIGHT
    JR Z,.currently_moving_right

    ; Moving left?
    CP _PACK_DIRECTION_LEFT
    JR Z,.currently_moving_left

    ; Moving down - is pack at the RHS of the screen?
    CP _PACK_DIRECTION_DOWN_AT_RIGHT
    JR Z,.currently_moving_down_at_right

    ; Movin down, pack is at LHS of the screen
    LD A,_PACK_DIRECTION_RIGHT                      ; Switch to moving right
    LD (_pack_direction),A

    JR .done

.currently_moving_down_at_right:
    LD A,_PACK_DIRECTION_LEFT                       ; Switch to moving left
    LD (_pack_direction),A

    JR .done

.currently_moving_right:
    ; Pack is moving right
    LD A,(_pack_x_reference)                        ; Get the reference X coord
    CP 96                                           ; Has the pack hit the RHS of the screen?
    JR C,.carry_on_right                            ; No, carry on in same direction

    ; Switch to moving down flagging pack is at right of screen
    LD A,_PACK_DIRECTION_DOWN_AT_RIGHT              
    LD (_pack_direction),A
    JR .done

.carry_on_right:
    LD A,(_pack_x_reference)                        ; Update the reference X coord
    INC A
    INC A
    LD (_pack_x_reference),A

    JR .done

.currently_moving_left:
    ; Pack is moving left
    LD A,(_pack_x_reference)                        ; Get the reference X coord
    CP 0x04                                         ; Has the pack hit the LHS of the screen?
    JR NC,.carry_on_left                            ; No, carry on in same direction

    ; Switch to moving down flagging pack is at left of screen
    LD A,_PACK_DIRECTION_DOWN_AT_LEFT             
    LD (_pack_direction),A
    JR .done

.carry_on_left:
    LD A,(_pack_x_reference)                        ; Update the reference X coord
    DEC A
    DEC A
    LD (_pack_x_reference),A
    JR .done

.done
    POP HL,AF

    RET

_move_alien:
    PUSH AF,DE,HL

     ; Current alient position
    LD HL,(_current_alien_ptr)              ; Current alien
    LD DE,(HL)                              ; Coords are at start of alien definition

    ; Is the pack moving left, right or down
    LD A,(_pack_direction)
    CP _PACK_DIRECTION_LEFT
    JR NZ,.not_moving_left                  ; No

    ; Moving left
    DEC D                                   ; Decrease the X coord by 2
    DEC D
    LD (_current_alien_new_coords),DE       ; Store new coords

    JR .done_moving

.not_moving_left:
    CP _PACK_DIRECTION_RIGHT                ; Is the pack moving right
    JR NZ,.moving_down                      ; No

    ; Moving right
    INC D                                   ; Increase X by 2
    INC D
    LD (_current_alien_new_coords),DE       ; Store new coords

    JR .done_moving

.moving_down:
    ; Moving down
    LD A,8                                  ; Increase Y by 8
    ADD A,E
    LD E,A
    LD (_current_alien_new_coords),DE       ; Store new coords

.done_moving:
    POP HL,DE,AF

    RET

_aliens:         
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

_ALIEN_PACK_SIZE:  EQU ($-_aliens)/6

update_current_alien:
    ; Calculate new coordinates of current alien
    CALL _move_alien

    ; Calculate address of sprite variant data to use
    CALL _select_sprite_variant

    RET

next_alien:
    PUSH DE,HL
    
    LD HL,(_current_alien_ptr)   

    ; Overwrite coordinate data of current alien
    LD DE,(_current_alien_new_coords)
    LD (HL),DE

    ; Move pointer to next alien sprite             
    LD DE,0x06                              
    ADD HL,DE
    LD (_current_alien_ptr),HL
    
    POP HL,DE
    
    RET

next_pack_cycle:
    PUSH AF,HL
    
    ; Do we need to change direction?
    CALL _adjust_alien_pack_direction

    ; Cycle which variant we'll draw
    LD HL,_current_pack_variant_flag
    LD A, (HL)
    XOR 0x01
    LD (_current_pack_variant_flag),A

    ; Reset current alien pointer to start of pack
    LD HL,_aliens
    LD (_current_alien_ptr),HL

    POP HL,AF

    RET

    ENDMODULE
