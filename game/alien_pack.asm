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
_STATE_OFFSET_VARIANT:                  EQU 11

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
    WORD 0X1060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X2060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X3060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X4060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X5060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X6060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X7060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X8060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X9060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0XA060,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0

    ; Row 1
    WORD 0X1050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X2050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X3050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X4050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X5050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X6050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X7050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X8050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X9050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0XA050,sprites.ALIEN_1_VARIANT_0,sprites.ALIEN_1_VARIANT_1,sprites.ALIEN_1_VARIANT_0_BLANK,sprites.ALIEN_1_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    
    ; Row 2
    WORD 0X1040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X2040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X3040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X4040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X5040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X6040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X7040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X8040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X9040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0XA040,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0

    ; Row 3
    WORD 0X1030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X2030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X3030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X4030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X5030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X6030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X7030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X8030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X9030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0XA030,sprites.ALIEN_2_VARIANT_0,sprites.ALIEN_2_VARIANT_1,sprites.ALIEN_2_VARIANT_0_BLANK,sprites.ALIEN_2_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0

    ; Row 4
    WORD 0X1020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X2020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X3020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X4020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X5020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X6020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X7020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X8020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0X9020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0
    WORD 0XA020,sprites.ALIEN_3_VARIANT_0,sprites.ALIEN_3_VARIANT_1,sprites.ALIEN_3_VARIANT_0_BLANK,sprites.ALIEN_3_VARIANT_1_BLANK
    BYTE _ALIEN_STATE_NEW,_ALIEN_VARIANT_0

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

_ALIEN_LOOKUP_LAST:                     EQU $-2

; Number of aliens in total in new pack
_ALIEN_PACK_SIZE:                       EQU ($-_ALIEN_LOOKUP)/2

_current_alien_lookup_ptr:              BLOCK 2         ; Pointer to the current alien in the lookup table     
_current_pack_variant_flag:             BLOCK 1         ; Current variant for walking animation taken from _ALIEN_VARIANT_* constants
_pack_direction:                        BLOCK 1         ; Current direction of alient pack taken from _PACK_DIRECTION_* constants
_pack_loop_counter:                     BLOCK 1         ; Loop counter decremented as each alien is processed so we know when to go back to start of the pack

_pack_bl_coords:
_pack_bottom:                           BLOCK 1
_pack_left:                             BLOCK 1

_pack_tr_coords:
_pack_top:                              BLOCK 1
_pack_right:                            BLOCK 1

_PACK_MAX_RIGHT:                        EQU layout.INSET_X_PIXELS+layout.INSET_SCREEN_WIDTH_PIXELS-((sprites.ALIEN_1_VARIANT_0_BLANK_DIM_X_BYTES-1)*8)
_PACK_MIN_LEFT:                         EQU layout.INSET_X_PIXELS

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

    ; Initial pack variant
    LD A,_ALIEN_VARIANT_0
    LD (_current_pack_variant_flag),A        

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

blank_alien:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    LD A,(IX+_STATE_OFFSET_STATE)
    BIT _ALIEN_STATE_DIEING_BIT,A
    JR NZ,.blank_explosion

    ; Is the current alien dead or new
    AND _ALIEN_STATE_DEAD | _ALIEN_STATE_NEW,A
    JR NZ,.done                                         ; Dead or new so nothing to do

    ; Blank old sprite position
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite mask based on variant
    LD A,(IX+_STATE_OFFSET_VARIANT)        
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IX+_STATE_OFFSET_VAR_0_BLANK)                ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IX+_STATE_OFFSET_VAR_1_BLANK)                ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

    JR .done

.blank_explosion
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL 

    LD HL,sprites.ALIEN_EXPLOSION_BLANK
    PUSH HL

    CALL fast_draw.fast_draw_sprite_16x8

    POP HL
    POP HL

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

draw_current_alien:
    PUSH AF,DE,HL,IX
    
     ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    ; Is the deferred alien active pr new
    LD A,(IX+_STATE_OFFSET_STATE)
    AND _ALIEN_STATE_ACTIVE|_ALIEN_STATE_NEW,A    
    JR Z,.done                                          ; Dead on dieing so don't draw

    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    ; Select sprite mask based on variant
    LD A,(_current_pack_variant_flag)                   ; Which variant are we currently using       
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         

    ; Using variant 0                         
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)
    PUSH HL 

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_0 
    JR .variant_selected

.variant_1_is_current:   
    ; Using variant 1
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE) 
    PUSH HL

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_1

.variant_selected:
    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

.done:
    POP IX,HL,DE,AF

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
    CP _PACK_MAX_RIGHT                                  ; Has the pack hit the RHS of the screen?
    JR C,.done                                          ; No, carry on in same direction

    ; Switch to moving down flagging pack is at right of screen
    LD A,_PACK_DIRECTION_DOWN_AT_RIGHT              
    LD (_pack_direction),A
    
    JR .done

.currently_moving_left:
    ; Pack is moving left
    LD A,(_pack_left)                                   ; Get the reference X coord
    CP _PACK_MIN_LEFT                                   ; Has the pack hit the LHS of the screen?
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
    LD (IX+_STATE_OFFSET_DRAW_COORDS),DE                ; Store new coords

    JR .done_moving

.not_moving_left:
    CP _PACK_DIRECTION_RIGHT                            ; Is the pack moving right
    JR NZ,.moving_down                                  ; No

    ; Moving right
    INC D                                               ; Increase X by 2
    INC D
    LD (IX+_STATE_OFFSET_DRAW_COORDS),DE                ; Store new coords

    JR .done_moving

.moving_down:
    ; Moving down
    LD A,8                                              ; Increase Y by 8
    ADD A,E
    LD E,A
    LD (IX+_STATE_OFFSET_DRAW_COORDS),DE                ; Store new coords

.done_moving:
    POP IX,HL,DE,AF

    RET

_update_pack_bounds:
    PUSH AF,DE
    LD DE,(IX+_STATE_OFFSET_DRAW_COORDS)                ; New x,y coords

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

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JR .done

.new:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_ACTIVE
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

    LD HL,(_current_alien_lookup_ptr) 
.loop
    ; Move to next alien in the lookup table
    LD A,(_pack_loop_counter)
    DEC A
    LD (_pack_loop_counter),A
    JR Z,.next_pack

    INC HL
    INC HL
    LD DE,(HL)
    LD IX,DE
    LD A,(IX+_STATE_OFFSET_STATE)
    BIT _ALIEN_STATE_DEAD_BIT,A
    JR NZ,.loop

    LD (_current_alien_lookup_ptr),HL
    JR .more_aliens_to_draw

.next_pack:
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

get_alien_at_coords:

._PARAM_COORDS:       EQU 16                            ; Coords to look for alien
._RTN_ALIEN_PTR       EQU 14                            ; Return value

    PUSH AF,BC,DE,HL,IX,IY

    ; Point IY to the stack
    LD  IY,0                                            
    ADD IY,SP   

    ; Flag hit not found
    LD (IY+._RTN_ALIEN_PTR), 0xFF                       
    LD (IY+._RTN_ALIEN_PTR+1), 0xFF

    ; Index of current alien
    LD A,0x00                                           
    LD (.alien_index),A

    ; Get the target coordinates and store for later
    LD HL,(IY+._PARAM_COORDS);
    LD (.target_coords),HL

    ; LOGPOINT [COLLISION] get_alien_at_coords: Target coords X=${H} Y=${L}

    ; Initialize pointer to scan through alien lookup table
    LD HL,_ALIEN_LOOKUP                                   
    LD (.alien_lookup_trace), HL                        

.y_loop
    ; Get current alien state
    LD HL,(.alien_lookup_trace)                         ; Get location in alien lookup table
    LD DE,(HL)                                          ; Dereference to get pointer to alien state
    LD IX,DE                                            ; Set IX to point to alien state

    ; Is the alien active?
    LD A,(IX+alien_pack._STATE_OFFSET_STATE);           ; Is alien active?
    BIT alien_pack._ALIEN_STATE_ACTIVE_BIT,A
    JR Z,.row_not_found                                 ; No - so skip it

    IFDEF DEBUG
        LD B,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)
        ; LOGPOINT [COLLISION] get_alien_at_coords: Testing top at ${B}
    ENDIF

    ; Is the target Y "below" to top of the alien - Y coords increase as we go down the screen
    LD A,(.target_y)                                    ; Y coord of collision
    CP (IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)      ; Compare to top of alien
    JR C,.row_not_found                                 ; Is the top of the alien coord greater than the target coord

    ; Is the target Y "above" the bottom of the alien?
    LD A,(.target_y)
    LD B,A
    LD A,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)
    ADD 0x08                                            ; Bottom of alien is at +8

    ; LOGPOINT [COLLISION] get_alien_at_coords: Testing bottom at ${A}

    CP B
    JR C,.row_not_found                                 ; Bottom of alien > target_y => not found

    ; LOGPOINT [COLLISION] get_alien_at_coords: Row match at index ${b@(alien_pack.get_alien_at_coords.alien_index)}

    JR .x_loop                                          ; We have found the correct row - now search for the correct column

.row_not_found:
    ; LOGPOINT [COLLISION] get_alien_at_coords: Not a row match

    ; Have we at the end of the list of aliens?
    LD A,(.alien_index)
    INC A
    CP _ALIEN_PACK_SIZE
    JR Z, .not_found
    LD (.alien_index),A

    ; Skip to next alien 
    LD HL,(.alien_lookup_trace)                        
    INC HL
    INC HL
    LD (.alien_lookup_trace),HL

    JR .y_loop                                          ; Try the next column

.x_loop:
    LD HL,(.alien_lookup_trace)                         ; Get location in alien lookup table
    LD DE,(HL)                                          ; Dereference to get pointer to alien state
    LD IX,DE                                            ; Point IX to alien state

    ; Is the alien active?
    LD A,(IX+alien_pack._STATE_OFFSET_STATE);           ; Is the alien active?
    BIT alien_pack._ALIEN_STATE_ACTIVE_BIT,A
    JR Z,.col_not_found                                 ; No - so skip it
   
    ; Is the target X <= alien RHS
    LD A,(.target_x)
    LD A,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)    ; Alien X coord
    ADD 14                                              ; RHS of alien is at +16  TODO
    LD B,A
    LD A,(.target_x)
    ; LOGPOINT [COLLISION] get_alien_at_coords: Testing RHS=${B}
    CP B                                                ; Compare alien RHS with target X
    JR NC,.col_not_found                                ; If target X is greater than alien RHS move to next

    ; Is the target X >= alien LHS
    IFDEF DEBUG
        LD B,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)
        ; LOGPOINT [COLLISION] get_alien_at_coords: Testing LHS at ${B}
    ENDIF
    LD A,(.target_x)
    INC A
    INC A
    CP (IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)                                              
    JR C,.col_not_found                                 ; No, so not this alien.  TODO Can we jump right to done here?

    ; Alien found
    ; LOGPOINT [COLLISION] get_alien_at_coords: Match found at index ${b@(alien_pack.get_alien_at_coords.alien_index)}

    ; Set the return value
    LD HL,(.alien_lookup_trace)                         
    LD DE,(HL)
    LD (IY+._RTN_ALIEN_PTR),E
    LD (IY+._RTN_ALIEN_PTR+1),D

    JR .done

.col_not_found:                                         ; Target column not found
    ; Are we at end of pack?
    LD A,(.alien_index)
    INC A
    CP _ALIEN_PACK_SIZE
    JR Z,.not_found
    LD (.alien_index),A

    LD HL,(.alien_lookup_trace)                         ; Move to next alien in lookup table
    INC HL
    INC HL
    LD (.alien_lookup_trace),HL
    JR .x_loop                                          ; Next alien

.not_found:
    ; LOGPOINT [COLLISION] get_alien_at_coords: Match NOT found
    NOP 

.done
    POP IY,IX,HL,DE,BC,AF

    RET

.alien_lookup_trace:    WORD 1
.target_coords:
.target_y:              BYTE 1
.target_x:              BYTE 1
.alien_index:           BYTE 1

alien_hit_by_player_missile:

.PARAM_ALIEN_STATE_PTR EQU 8

    PUSH HL,IX,IY

    ; Point IX to the stack
    LD  IX,0                                            
    ADD IX,SP   

    ; Pointer the the alien state of the collided alien
    LD HL,(IX+.PARAM_ALIEN_STATE_PTR)

    ; Set the alien state to be dieing
    LD IY,HL
    LD (IY+alien_pack._STATE_OFFSET_STATE),_ALIEN_STATE_DIEING

    ; Blank out the alien
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite mask based on variant
    LD A,(IY+_STATE_OFFSET_VARIANT)                     
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IY+_STATE_OFFSET_VAR_0_BLANK)                ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IY+_STATE_OFFSET_VAR_1_BLANK)                ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

    ; Draw alien explosion
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    LD HL,sprites.ALIEN_EXPLOSION;
    PUSH HL
  
    CALL fast_draw.fast_draw_sprite_16x8

    POP HL
    POP HL

    POP IY,IX,HL

    RET

    MEMORY_USAGE "alien pack      ",_module_start

    ENDMODULE
