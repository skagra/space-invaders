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
_ALIEN_STATE_DEAD:                      EQU 0b00000100  ; Dead alien

_ALIEN_STATE_NEW_BIT:                   EQU 0
_ALIEN_STATE_ACTIVE_BIT:                EQU 1
_ALIEN_STATE_DEAD_BIT:                  EQU 2

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

; Gap between aliens (top left to top left)
_ALIEN_X_OFFSET:                        EQU 0x10
_ALIEN_Y_OFFSET:                        EQU 0x10

_current_alien_lookup_ptr:              BLOCK 2         ; Pointer to the current alien in the lookup table     
_current_pack_variant_flag:             BLOCK 1         ; Current variant for walking animation taken from _ALIEN_VARIANT_* constants
_pack_direction:                        BLOCK 1         ; Current direction of alient pack taken from _PACK_DIRECTION_* constants
_pack_loop_counter:                     BLOCK 1         ; Loop counter decremented as each alien is processed so we know when to go back to start of the pack

; Pack bounds
_pack_bl_coords:
_pack_bottom:                           BLOCK 1
_pack_left:                             BLOCK 1

_pack_tr_coords:
_pack_top:                              BLOCK 1
_pack_right:                            BLOCK 1

; Global state governing pack when an alien is exploding
_exploding_cycles:                      BYTE 1
_exploding_alien:                       WORD 1
_pack_halted:                           BYTE 1

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

    ; Pointer to pack data
    LD HL,_ALIEN_LOOKUP                            
    LD (_current_alien_lookup_ptr),HL

    ; Initial pack variant
    LD A,_ALIEN_VARIANT_0
    LD (_current_pack_variant_flag),A        

    ; Pack loop counter
    LD A,_ALIEN_PACK_SIZE
    LD (_pack_loop_counter),A

    LD A,0x00
    LD (_pack_halted),A

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
    LD A,.PACK_MIN_LEFT
    LD (_pack_right),A

    JR .done

.currently_moving_down_at_right:
    LD A,_PACK_DIRECTION_LEFT                           ; Switch to moving left
    LD (_pack_direction),A

    ; Reset pack left
    LD A,.PACK_MAX_RIGHT
    LD (_pack_left),A

    JR .done

.currently_moving_right:
    ; Pack is moving right
    LD A,(_pack_right)                                  ; Get the reference X coord
    CP .PACK_MAX_RIGHT                                  ; Has the pack hit the RHS of the screen?
    JR C,.done                                          ; No, carry on in same direction

    ; Switch to moving down flagging pack is at right of screen
    LD A,_PACK_DIRECTION_DOWN_AT_RIGHT              
    LD (_pack_direction),A
    
    JR .done

.currently_moving_left:
    ; Pack is moving left
    LD A,(_pack_left)                                   ; Get the reference X coord
    CP .PACK_MIN_LEFT                                   ; Has the pack hit the LHS of the screen?
    JR NC,.done                                         ; No, carry on in same direction

    ; Switch to moving down flagging pack is at left of screen
    LD A,_PACK_DIRECTION_DOWN_AT_LEFT             
    LD (_pack_direction),A
    
.done
    POP HL,AF

    RET

; Limits of pack movement left and right before switching direction
.PACK_MAX_RIGHT:                        EQU draw_common.INSET_X_PIXELS+draw_common.INSET_SCREEN_WIDTH_PIXELS-((sprites.ALIEN_1_VARIANT_0_BLANK_DIM_X_BYTES-1)*8)
.PACK_MIN_LEFT:                         EQU draw_common.INSET_X_PIXELS

;------------------------------------------------------------------------------
;
; Update the location of the current alien
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

_move_current_alien:
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

_update_halted_pack:
    PUSH AF

    ; Is the pack halted
    LD A,(_pack_halted)
    AND A
    JR Z,.done

    ; Is there an alien that is currently exploding?
    LD A,(_exploding_cycles)  
    AND A                                               ; CP 0x00
    JR Z,.done                                          ; No - normal update cycle
    DEC A                                               ; Yes - decrease the number of cycles left to wait
    LD (_exploding_cycles),A                            ; Has the counter now dropped to zero?
    AND A                                               ; CP 0x00
    JR NZ,.done                                         ; No - done.

    ; Done exploding - erase the explosion
    LD HL,(_exploding_alien)                            ; Yes - blank the explosion
    LD IX,HL
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)
    PUSH HL
    LD HL, sprites.ALIEN_EXPLOSION_BLANK
    PUSH HL
    call fast_draw.draw_sprite_16x8
    POP HL
    POP HL 

    ; Start the pack moving again
    LD A,0x00
    LD (_pack_halted),A

.done
    POP AF
    
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

    ; Update if the pack is halted 
    CALL _update_halted_pack

    ; Is the pack still globally halted?
    LD A,(_pack_halted)
    AND A
    JR NZ,.done

.not_exploding

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

    BIT _ALIEN_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JR .done

.new:
    LD (IX+_STATE_OFFSET_STATE),_ALIEN_STATE_ACTIVE
    JR .done

.active:
    CALL _move_current_alien
    CALL _update_pack_bounds
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

    LD A,(_pack_halted)
    AND A
    JR NZ,.done

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
    JR .done

.next_pack:
    CALL _next_pack_cycle
    LD A,_ALIEN_PACK_SIZE
    LD (_pack_loop_counter),A

.done

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

alien_hit_by_player_missile:

.PARAM_ALIEN_STATE_PTR EQU 8 

    PUSH HL,IX,IY

    ; Point IX to the stack
    LD  IX,0                                            
    ADD IX,SP   

    ; Pointer to the collided alien
    LD HL,(IX+.PARAM_ALIEN_STATE_PTR)

    ; Store it
    LD (_exploding_alien),HL

    ; Halt the pack during the explosion
    LD A,0x01
    LD (_pack_halted),A

    ; Set the alien state to be dead
    LD IY,HL
    LD (IY+alien_pack._STATE_OFFSET_STATE),_ALIEN_STATE_DEAD 

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

    CALL fast_draw.draw_sprite_16x8
    POP DE
    POP DE

    ; Draw alien explosion
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  
    LD HL,sprites.ALIEN_EXPLOSION;
    PUSH HL
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL

    ; Set a count down to pause the movement of the pack
    LD A,.EXPLODING_ALIEN_DELAY
    LD (_exploding_cycles),A

    POP IY,IX,HL

    RET

.EXPLODING_ALIEN_DELAY EQU  15



