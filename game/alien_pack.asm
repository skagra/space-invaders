    MODULE alien_pack

_PACK_DIRECTION_LEFT:                   EQU 0b00000001   
_PACK_DIRECTION_RIGHT:                  EQU 0b00000010
_PACK_DIRECTION_DOWN_AT_LEFT:           EQU 0b00000100
_PACK_DIRECTION_DOWN_AT_RIGHT:          EQU 0b00001000

_PACK_DIRECTION_LEFT_BIT:               EQU 0   
_PACK_DIRECTION_RIGHT_BIT:              EQU 1
_PACK_DIRECTION_DOWN_AT_LEFT_BIT:       EQU 2
_PACK_DIRECTION_DOWN_AT_RIGHT_BIT:      EQU 3

_ALIEN_STATE_NEW:                       EQU 0b00000001
_ALIEN_STATE_ACTIVE:                    EQU 0b00000010
_ALIEN_STATE_DIEING:                    EQU 0b00000100
_ALIEN_STATE_DEAD:                      EQU 0b00001000

_ALIEN_STATE_NEW_BIT:                   EQU 0
_ALIEN_STATE_ACTIVE_BIT:                EQU 1
_ALIEN_STATE_DIEING_BIT:                EQU 2
_ALIEN_STATE_DEAD_BIT:                  EQU 3

_STATE_OFFSET_DRAW_COORDS:              EQU 0
_STATE_OFFSET_VAR_0_SPRITE:             EQU 2
_STATE_OFFSET_VAR_1_SPRITE:             EQU 4
_STATE_OFFSET_STATE:                    EQU 6

_AS_SIZE:                               EQU 8

_ALIEN_VARIANT_0:                       EQU 0b00000001

_ALIEN_VARIANT_1:                       EQU 0b00000010

_ALIEN_VARIANT_0_BIT:                   EQU 0
_ALIEN_VARIANT_1_BIT:                   EQU 1

; _aliensx:         
;     WORD 0x1060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
;     WORD 0x6060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

;     WORD 0x1050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
;     WORD 0x6050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

;     WORD 0x1040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
;     WORD 0x6040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

;     WORD 0x1030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
;     WORD 0x6030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

;     WORD 0x1020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x2020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x3020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x4020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x5020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1
;     WORD 0x6020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x7020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x8020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x9020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0xA020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1


_alien_state:
    ; Bottom row - row 0
    WORD 0x1060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x2060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x3060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x4060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x5060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x6060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x7060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x8060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x9060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0xA060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW

    ; Row 1
    WORD 0x1050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x2050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x3050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x4050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x5050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    WORD 0x6050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x7050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x8050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0x9050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW 
    WORD 0xA050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,_ALIEN_STATE_NEW
    
    ; Row 2
    WORD 0x1040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW
    WORD 0x2040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x3040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x4040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x5040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW
    WORD 0x6040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x7040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x8040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0x9040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW 
    WORD 0xA040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,_ALIEN_STATE_NEW


_ALIEN_LOOKUP:
    ; Row 0 (bottom of pack)
    WORD _alien_state+_AS_SIZE*0, _alien_state+_AS_SIZE*1, _alien_state+_AS_SIZE*2, _alien_state+_AS_SIZE*3, _alien_state+_AS_SIZE*4 
    WORD _alien_state+_AS_SIZE*5, _alien_state+_AS_SIZE*6, _alien_state+_AS_SIZE*7, _alien_state+_AS_SIZE*8, _alien_state+_AS_SIZE*9
    WORD _alien_state+_AS_SIZE*10, _alien_state+_AS_SIZE*11, _alien_state+_AS_SIZE*12, _alien_state+_AS_SIZE*13, _alien_state+_AS_SIZE*14 
    WORD _alien_state+_AS_SIZE*15, _alien_state+_AS_SIZE*16, _alien_state+_AS_SIZE*17, _alien_state+_AS_SIZE*18, _alien_state+_AS_SIZE*19
    WORD _alien_state+_AS_SIZE*20, _alien_state+_AS_SIZE*21, _alien_state+_AS_SIZE*22, _alien_state+_AS_SIZE*23, _alien_state+_AS_SIZE*24 
    WORD _alien_state+_AS_SIZE*25, _alien_state+_AS_SIZE*26, _alien_state+_AS_SIZE*27, _alien_state+_AS_SIZE*28, _alien_state+_AS_SIZE*29
    ; ...

ALIEN_PACK_SIZE:                        EQU 10; ($-_ALIEN_LOOKUP)/2

_current_alien_lookup_ptr:              BLOCK 2      
_current_pack_variant_flag:             BLOCK 1
_pack_x_reference:                      BLOCK 1
_pack_direction:                        BLOCK 1
_current_alien_new_coords:              BLOCK 2
_deferred_alien_lookup: WORD 2

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
;
;------------------------------------------------------------------------------

init:
    PUSH AF,HL

    ; Alien pack direction
    LD A,_PACK_DIRECTION_RIGHT
    LD (_pack_direction),A

    ; Reference pack X coord
    ; LD IX,_alien_state
    ; LD A,(IX+_STATE_OFFSET_DRAW_COORDS)
    LD A,0x10                               ; TODO
    LD (_pack_x_reference),A

    ; Pack variant
    LD A,_ALIEN_VARIANT_1
    LD (_current_pack_variant_flag),A

    ; Pointer to pack data
    LD HL,_ALIEN_LOOKUP                            
    LD (_current_alien_lookup_ptr),HL

    LD (_deferred_alien_lookup),HL

    POP HL,AF

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
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    ; Is the current alien dead or new
    LD A,(IX+_STATE_OFFSET_STATE)
    AND _ALIEN_STATE_DEAD | _ALIEN_STATE_NEW,A
    JR NZ,.done                                         ; Dead or new so nothing to do

    ; Blank old sprite position
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)               ; Coords
    PUSH HL     

    ; HACK
    LD DE, 0x0308                                       ; Dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_2b_x_8px                 ; Background square sprite
    PUSH DE

    ; Select sprite mask based on variant
    LD A,(_current_pack_variant_flag)          
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE)               ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)               ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    CALL draw.draw_sprite

    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP IX,HL,DE,AF

    RET

draw_deferred_alien:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_deferred_alien_lookup) ; TODO what I reaaly need to do is to store the old pointer so I get old state, graphic etc.
    LD DE,(HL)
    LD IX,DE
    
    ; Is the current alien active
    LD A,(IX+_STATE_OFFSET_STATE)
    AND  _ALIEN_STATE_DEAD|_ALIEN_STATE_DIEING,A   ; TODO FIx need new coords initing
    JR NZ,.done                                          ; Dead on dieing so don't draw

   LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    // LD HL,(_current_alien_new_coords)       ; Coords TODO - NOT SET FIRST TIME?
    PUSH HL  

    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE

    ; Select sprite and mask based on variant
    LD A,(_current_pack_variant_flag)          
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current              ; Opposite to current sprite for blanking
                             
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)    ; Sprite and mask 
    JR .variant_selected

.variant_1_is_current:  
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE)    ; Sprite and mask 

.variant_selected:
    PUSH HL                                     ; Sprite                     
    PUSH HL                                     ; Mask

    CALL draw.draw_sprite

    POP DE
    POP DE
    POP DE
    POP DE

.done:

    POP IX,HL,DE,AF

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

_calc_current_alien_new_coords:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    ; Get current draw coords
    LD DE,(IX+_STATE_OFFSET_DRAW_COORDS)

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
    POP IX,HL,DE,AF

    RET

next_alien:
     PUSH AF,DE,HL,IX
    
    ; Update current alien's coords

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE

    ; Copy new coords into current alien
    LD HL,(_current_alien_new_coords)    
    LD (IX+_STATE_OFFSET_DRAW_COORDS),HL

    ; Move to next alien in the lookup table
    LD HL,(_current_alien_lookup_ptr) 
    LD (_deferred_alien_lookup),HL

    INC HL
    INC HL
    LD (_current_alien_lookup_ptr),HL ; TODO - Search for next non-dead alien

    POP IX,DE,HL,AF
    
    RET

update_current_alien:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE

    ; Get current aliens state
    LD A,(IX+_STATE_OFFSET_STATE)

    ; If the alien is dead then there is nothing to do
    BIT _ALIEN_STATE_DEAD_BIT,A
    JR NZ,.done

    ; Is the alien new
    BIT _ALIEN_STATE_NEW_BIT,A
    JR NZ,.new

    ; Is the alien dieing?
    BIT _ALIEN_STATE_DIEING_BIT,A
    JR NZ,.dieing

    BIT _ALIEN_STATE_ACTIVE_BIT,A
    JR NZ,.active

    // This should never be reached!
    JR .done

.new:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_ACTIVE
    CALL _calc_current_alien_new_coords
    JR .done

.dieing:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_DEAD
    JR .done

.active:
    CALL _calc_current_alien_new_coords


.done

    POP IX,HL,DE,AF

    RET

next_pack_cycle:
    PUSH AF,HL
    
    ; Do we need to change direction?
    CALL _adjust_alien_pack_direction

    ; Cycle which variant we'll draw
    LD HL,_current_pack_variant_flag 
    LD A, (HL)
    XOR _ALIEN_VARIANT_0 | _ALIEN_VARIANT_1
    LD (_current_pack_variant_flag),A

    ; Reset current alien pointer to start of pack
    LD HL,_ALIEN_LOOKUP                            
    LD (_current_alien_lookup_ptr),HL

    POP HL,AF

    RET

    ENDMODULE



; _aliensx:         
;     WORD 0x1060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
;     WORD 0x6060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

;     WORD 0x1050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x2050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x3050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x4050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x5050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1
;     WORD 0x6050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x7050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x8050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0x9050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1, 0xA050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1

;     WORD 0x1040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
;     WORD 0x6040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

;     WORD 0x1030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x2030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x3030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x4030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x5030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1
;     WORD 0x6030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x7030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x8030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0x9030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1, 0xA030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1

;     WORD 0x1020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x2020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x3020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x4020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x5020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1
;     WORD 0x6020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x7020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x8020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0x9020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1, 0xA020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1
