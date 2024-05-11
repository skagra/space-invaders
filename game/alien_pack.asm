    MODULE alien_pack

_module_start:

; Direction of movement of alien pack
_PACK_DIRECTION_LEFT:                   EQU 0b00000001   
_PACK_DIRECTION_RIGHT:                  EQU 0b00000010
_PACK_DIRECTION_DOWN_AT_LEFT:           EQU 0b00000100
_PACK_DIRECTION_DOWN_AT_RIGHT:          EQU 0b00001000

_PACK_DIRECTION_LEFT_BIT:               EQU 0   
_PACK_DIRECTION_RIGHT_BIT:              EQU 1
_PACK_DIRECTION_DOWN_AT_LEFT_BIT:       EQU 2
_PACK_DIRECTION_DOWN_AT_RIGHT_BIT:      EQU 3

; Status of an alien
_ALIEN_STATE_NEW:                       EQU 0b00000001  ; Just created
_ALIEN_STATE_ACTIVE:                    EQU 0b00000010  ; Normally active alien
_ALIEN_STATE_DIEING:                    EQU 0b00000100  ; In the process of dieing
_ALIEN_STATE_DEAD:                      EQU 0b00001000  ; Dead alien

_ALIEN_STATE_NEW_BIT:                   EQU 0
_ALIEN_STATE_ACTIVE_BIT:                EQU 1
_ALIEN_STATE_DIEING_BIT:                EQU 2
_ALIEN_STATE_DEAD_BIT:                  EQU 3

; Offsets into structure representing an alien
_STATE_OFFSET_DRAW_COORDS:              EQU 0           ; Coords
_STATE_OFFSET_DRAW_COORDS_Y:            EQU _STATE_OFFSET_DRAW_COORDS
_STATE_OFFSET_DRAW_COORDS_X:            EQU _STATE_OFFSET_DRAW_COORDS+1
_STATE_OFFSET_VAR_0_SPRITE:             EQU 2           ; First variant sprite
_STATE_OFFSET_VAR_1_SPRITE:             EQU 4           ; Second variant sprite
_STATE_OFFSET_VAR_0_BLANK:              EQU 6           ; First variant blank
_STATE_OFFSET_VAR_1_BLANK:              EQU 8           ; Second variant blank
_STATE_OFFSET_STATE:                    EQU 10          ; Status of sprite from _ALIEN_STATE_* values

_AS_SIZE:                               EQU 12          ; Size of the alien sprite structure

; Current alien variant for walking animation
_ALIEN_VARIANT_0:                       EQU 0b00000001
_ALIEN_VARIANT_1:                       EQU 0b00000010

_ALIEN_VARIANT_0_BIT:                   EQU 0
_ALIEN_VARIANT_1_BIT:                   EQU 1

_ALIEN_X_OFFSET:                        EQU 0x10
_ALIEN_Y_OFFSET:                        EQU 0x10


_ALIEN_ROWS:                            EQU 5
_ALIEN_COLS:                            EQU 10
_ALIEN_LEFT:                            EQU 0x10
_ALIEN_BOTTOM:                          EQU 0x20


; Alien pack as per _STATE_OFFSET_* constants
_alien_state:
    ; Bottom row - Row 0
    WORD 0x1060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x2060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x3060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x4060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x5060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x6060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x7060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x8060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x9060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0xA060,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW

    ; Row 1
    WORD 0x1050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x2050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x3050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x4050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x5050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x6050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x7050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x8050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x9050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0xA050,sprites.sprite_alien_1_variant_0,sprites.sprite_alien_1_variant_1,sprites.sprite_alien_1_variant_0_blank,sprites.sprite_alien_1_variant_1_blank,_ALIEN_STATE_NEW
    
    ; Row 2
    WORD 0x1040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x2040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x3040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x4040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x5040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x6040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x7040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x8040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x9040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0xA040,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW

    ; Row 3
    WORD 0x1030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x2030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x3030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x4030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x5030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x6030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x7030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x8030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x9030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0xA030,sprites.sprite_alien_2_variant_0,sprites.sprite_alien_2_variant_1,sprites.sprite_alien_2_variant_0_blank,sprites.sprite_alien_2_variant_1_blank,_ALIEN_STATE_NEW

    ; Row 4
    WORD 0x1020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x2020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x3020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x4020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x5020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW
    WORD 0x6020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x7020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x8020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0x9020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW 
    WORD 0xA020,sprites.sprite_alien_3_variant_0,sprites.sprite_alien_3_variant_1,sprites.sprite_alien_3_variant_0_blank,sprites.sprite_alien_3_variant_1_blank,_ALIEN_STATE_NEW

; Lookup table into _alien_state table
_ALIEN_LOOKUP:
    ; Row 0 (bottom of pack)
    WORD _alien_state+_AS_SIZE*0, _alien_state+_AS_SIZE*1, _alien_state+_AS_SIZE*2, _alien_state+_AS_SIZE*3, _alien_state+_AS_SIZE*4 
    WORD _alien_state+_AS_SIZE*5, _alien_state+_AS_SIZE*6, _alien_state+_AS_SIZE*7, _alien_state+_AS_SIZE*8, _alien_state+_AS_SIZE*9
    ; Row 1
    WORD _alien_state+_AS_SIZE*10, _alien_state+_AS_SIZE*11, _alien_state+_AS_SIZE*12, _alien_state+_AS_SIZE*13, _alien_state+_AS_SIZE*14 
    WORD _alien_state+_AS_SIZE*15, _alien_state+_AS_SIZE*16, _alien_state+_AS_SIZE*17, _alien_state+_AS_SIZE*18, _alien_state+_AS_SIZE*19
    ; Row 2
    WORD _alien_state+_AS_SIZE*20, _alien_state+_AS_SIZE*21, _alien_state+_AS_SIZE*22, _alien_state+_AS_SIZE*23, _alien_state+_AS_SIZE*24 
    WORD _alien_state+_AS_SIZE*25, _alien_state+_AS_SIZE*26, _alien_state+_AS_SIZE*27, _alien_state+_AS_SIZE*28, _alien_state+_AS_SIZE*29
    ; Row 3
    WORD _alien_state+_AS_SIZE*30, _alien_state+_AS_SIZE*31, _alien_state+_AS_SIZE*32, _alien_state+_AS_SIZE*33, _alien_state+_AS_SIZE*34 
    WORD _alien_state+_AS_SIZE*35, _alien_state+_AS_SIZE*36, _alien_state+_AS_SIZE*37, _alien_state+_AS_SIZE*38, _alien_state+_AS_SIZE*39  
    ; Row 4
    WORD _alien_state+_AS_SIZE*40, _alien_state+_AS_SIZE*41, _alien_state+_AS_SIZE*42, _alien_state+_AS_SIZE*43, _alien_state+_AS_SIZE*44 
    WORD _alien_state+_AS_SIZE*45, _alien_state+_AS_SIZE*46, _alien_state+_AS_SIZE*47, _alien_state+_AS_SIZE*48, _alien_state+_AS_SIZE*49
    
; Number of aliens in total in new pack
_ALIEN_PACK_SIZE:                       EQU ($-_ALIEN_LOOKUP)/2

_current_alien_lookup_ptr:              BLOCK 2         ; Pointer to the current alien in the lookup table     
_current_pack_variant_flag:             BLOCK 1         ; Current variant for walking animation taken from _ALIEN_VARIANT_* constants
_pack_direction:                        BLOCK 1         ; Current direction of alient pack taken from _PACK_DIRECTION_* constants
_pack_loop_counter:                     BLOCK 1         ; Loop counter decremented as each alien is processed so we know when to go back to start of the pack

_current_alien_new_coords:              BLOCK 2         ; Calculated new coordinates of the current alien

_deferred_alien_state:                  BLOCK 2         ; Alien state used for deferred drawing
_deferred_alien_sprite:                 BLOCK 2         ; Alien sprite used for deferred drawing
_deferred_alien_coords:                 BLOCK 2         ; Alien coords used for deferred drawing

_pack_bl_coords:
_pack_bottom:                           BLOCK 1
_pack_left:                             BLOCK 1

_pack_tr_coords:
_pack_top:                              BLOCK 1
_pack_right:                            BLOCK 1

_PACK_MAX_RIGHT:                        EQU 240
_PACK_MIN_LEFT:                         EQU 3

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
    PUSH AF,DE,HL

    ; Alien pack direction
    LD A,_PACK_DIRECTION_RIGHT
    LD (_pack_direction),A
  
    ; Reference pack X coord
    ; LD A,0x10                               ; TODO - proper way to determine x reference (actually this might go altogether)
    ; LD (_pack_x_reference),A

    ; Pointer to pack data
    LD HL,_ALIEN_LOOKUP                            
    LD (_current_alien_lookup_ptr),HL

    ; Pack variant
    LD HL,_alien_state
    INC HL
    INC HL
    INC HL
    INC HL
    LD DE,(HL)
    LD (_deferred_alien_sprite),DE

    ; First state
    LD A,_ALIEN_STATE_NEW
    LD (_deferred_alien_state),A

    LD HL, 0x1060
    LD (_deferred_alien_coords),HL

    ; Pack loop counter
    LD A,_ALIEN_PACK_SIZE
    LD (_pack_loop_counter),A

    ; Pack extremeties
    ; TODO proper way of setting initial values
    LD A,0x20
    LD (_pack_bottom),A  

    LD A,0x10
    LD (_pack_left),A
    
    LD A,0x60
    LD (_pack_top),A
    
    LD A,0xA0
    LD (_pack_right),A                      


    POP HL,DE,AF

    RET

;------------------------------------------------------------------------------
;
; Erase current alien
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
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite mask based on variant
    LD A,(_current_pack_variant_flag)          
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IX+_STATE_OFFSET_VAR_1_BLANK)               ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IX+_STATE_OFFSET_VAR_0_BLANK)               ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

.done
    POP IX,HL,DE,AF

    RET

;------------------------------------------------------------------------------
;
; Deferred draw of alien using _deferred_* values
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

draw_deferred_alien:
    PUSH AF,DE,HL
    
    ; Is the deferred alien active pr new
    LD A,(_deferred_alien_state)
    AND _ALIEN_STATE_ACTIVE|_ALIEN_STATE_NEW,A    
    JR Z,.done                                          ; Dead on dieing so don't draw

    LD HL,(_deferred_alien_coords)                      ; Coords
    PUSH HL  

    LD HL,(_deferred_alien_sprite) 
    PUSH HL                                             ; Sprite

    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

.done:
    POP HL,DE,AF

    RET

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
    LD A,_PACK_DIRECTION_RIGHT                          ; Switch to moving right
    LD (_pack_direction),A

    ; Reset pack right 
    LD A,_PACK_MIN_LEFT
    LD (_pack_right),A

    JR .done

.currently_moving_down_at_right:
    LD A,_PACK_DIRECTION_LEFT                           ; Switch to moving left
    LD (_pack_direction),A

    ; Reset pack left
    LD A,_PACK_MAX_RIGHT
    LD (_pack_left),A

    JR .done

.currently_moving_right:
    ; Pack is moving right
    LD A,(_pack_right)                                  ; Get the reference X coord
    CP _PACK_MAX_RIGHT                                      ; Has the pack hit the RHS of the screen?
    JR C,.done                                          ; No, carry on in same direction

    ; Switch to moving down flagging pack is at right of screen
    LD A,_PACK_DIRECTION_DOWN_AT_RIGHT              
    LD (_pack_direction),A
    
    JR .done

.currently_moving_left:
    ; Pack is moving left
    LD A,(_pack_left)                                   ; Get the reference X coord
    CP _PACK_MIN_LEFT                                      ; Has the pack hit the LHS of the screen?
    JR NC,.done                                         ; No, carry on in same direction

    ; Switch to moving down flagging pack is at left of screen
    LD A,_PACK_DIRECTION_DOWN_AT_LEFT             
    LD (_pack_direction),A
    
.done
    POP HL,AF

    RET

;------------------------------------------------------------------------------
;
; Calcuate the coordinates the current alien will move to, storing
; result in _current_alien_new_coords
;
; Usage:
;   CALL _calc_current_alien_new_coords
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------
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
    JR NZ,.not_moving_left                              ; No

    ; Moving left
    DEC D                                               ; Decrease the X coord by 2
    DEC D
    LD (_current_alien_new_coords),DE                   ; Store new coords

    JR .done_moving

.not_moving_left:
    CP _PACK_DIRECTION_RIGHT                            ; Is the pack moving right
    JR NZ,.moving_down                                  ; No

    ; Moving right
    INC D                                               ; Increase X by 2
    INC D
    LD (_current_alien_new_coords),DE                   ; Store new coords

    JR .done_moving

.moving_down:
    ; Moving down
    LD A,8                                              ; Increase Y by 8
    ADD A,E
    LD E,A
    LD (_current_alien_new_coords),DE                   ; Store new coords

.done_moving:
    POP IX,HL,DE,AF

    RET

_update_pack_bounds:
    PUSH AF,DE
    LD DE,(_current_alien_new_coords)                   ; New x,y coords

    ; What direction is the pack travelling
    LD A,(_pack_direction)

    ; Travelling left
    BIT _PACK_DIRECTION_LEFT_BIT,A
    JR NZ, .travelling_left

    ; Travelling right
    BIT _PACK_DIRECTION_RIGHT_BIT,A
    JR NZ, .travelling_right

    ; Travelling down
    LD HL,_pack_bottom
    LD A,(HL)
    CP E
    JR NC,.done

    LD (HL),E
    JR .done

.travelling_left:
    LD HL,_pack_left
    LD A,(HL)
    CP D
    JR C,.done

    LD (HL),D
    JR .done

.travelling_right:
    LD HL,_pack_right
    LD A,(HL)
    CP D
    JR NC,.done
    LD (HL),D

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
;
; Update the current alien coordinates and state
;
; Usage:
;   CALL update_current_alien
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

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
    JR NZ,.dead

    ; Is the alien new
    BIT _ALIEN_STATE_NEW_BIT,A
    JR NZ,.new

    ; Is the alien dieing?
    BIT _ALIEN_STATE_DIEING_BIT,A
    JR NZ,.dieing

    BIT _ALIEN_STATE_ACTIVE_BIT,A
    JR NZ,.active

    // This should never be reached!
    DB_FLAG_ERROR error_codes.UDC_SHOULD_NOT_BE_REACHED

    JR .done

.new:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_ACTIVE
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)

    ; New alien - first time deferred draw so don't move
    LD (_current_alien_new_coords),HL

    JR .done

.active:
    CALL _calc_current_alien_new_coords
    CALL _update_pack_bounds
    JR .done

.dieing:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_DEAD
    JR .done

.dead:

.done
    POP IX,HL,DE,AF

    RET

;------------------------------------------------------------------------------
;
; Move on to the next alien in the pack
;
; Usage:
;   CALL next_alien
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

next_alien:
    PUSH AF,DE,HL,IX
    
    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE

    ; Set up the deferred draw
    LD HL,(_current_alien_new_coords)                   ; Coords
    LD (_deferred_alien_coords),HL    

    LD HL,(IX+_STATE_OFFSET_STATE)                      ; State
    LD (_deferred_alien_state),HL

    LD A,(_current_pack_variant_flag)                   ; Variant         
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1   

    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)               ; Sprite and mask variant 0
    LD (_deferred_alien_sprite),HL
    JR .variant_done

.variant_1:  
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE)               ; Sprite and mask variant 1
    LD (_deferred_alien_sprite),HL

.variant_done:
    ; Copy new coords into current alien
    LD HL,(_current_alien_new_coords)    
    LD (IX+_STATE_OFFSET_DRAW_COORDS),HL 

    ; Move to next alien in the lookup table
    LD HL,(_current_alien_lookup_ptr) 
    INC HL
    INC HL
    LD (_current_alien_lookup_ptr),HL ; TODO - Search for next non-dead alien - 

    ; Are we done drawing the entire pack?
    LD A,(_pack_loop_counter)
    DEC A
    LD (_pack_loop_counter),A
    JR NZ,.more_aliens_to_draw

    CALL _next_pack_cycle
    LD A,_ALIEN_PACK_SIZE
    LD (_pack_loop_counter),A

.more_aliens_to_draw

    POP IX,DE,HL,AF
    
    RET

;------------------------------------------------------------------------------
;
; Finished a complete cycle of drawing the pack, set up for next cycle
;
; Usage:
;   CALL _next_pack_cycle
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

_next_pack_cycle:
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

    DEBUG_CYCLE_FLASH

    RET

    MEMORY_USAGE "alien pack      ",_module_start

    ENDMODULE
