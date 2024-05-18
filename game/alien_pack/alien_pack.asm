; Direction of movement of alien pack
_PACK_DIRECTION_LEFT:                   EQU 0b00000001   
_PACK_DIRECTION_RIGHT:                  EQU 0b00000010
_PACK_DIRECTION_DOWN_AT_LEFT:           EQU 0b00000100
_PACK_DIRECTION_DOWN_AT_RIGHT:          EQU 0b00001000

_PACK_DIRECTION_LEFT_BIT:               EQU 0   
_PACK_DIRECTION_RIGHT_BIT:              EQU 1
_PACK_DIRECTION_DOWN_AT_LEFT_BIT:       EQU 2
_PACK_DIRECTION_DOWN_AT_RIGHT_BIT:      EQU 3

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

; State governing pack when an alien is exploding
_exploding_alien:                       BLOCK 2
_pack_halted:                           BLOCK 1

; Current number of aliens
_alien_count:                           BLOCK 1

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
    
    LD A,0xB0
    LD (_pack_right),A                      

    LD A,_ALIEN_PACK_SIZE
    LD (_alien_count),A

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
.PACK_MAX_RIGHT:                        EQU layout.INSET_X_PIXELS+layout.INSET_SCREEN_WIDTH_PIXELS-((sprites.ALIEN_1_VARIANT_0_DIM_X_BYTES-1)*8)
.PACK_MIN_LEFT:                         EQU layout.INSET_X_PIXELS

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

    ; If there is just one alien left then it moves more quickly when travelling right
    LD A,(_alien_count)
    CP 0x01
    JR NZ,.more_than_one_alien

    INC D

.more_than_one_alien
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

event_alien_explosion_done:
    PUSH AF,HL

    ; Done exploding - erase the explosion
    LD HL,(_exploding_alien)                           
    LD IX,HL

    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)
    PUSH HL

    LD HL, sprites.ALIEN_EXPLOSION
    PUSH HL

    LD L,utils.TRUE_VALUE
    PUSH HL

    CALL fast_draw.draw_sprite_16x8
    
    POP HL  
    POP HL
    POP HL 

    ; Start the pack moving again
    LD A,0x00   
    LD (_pack_halted),A

    POP HL,AF

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

update:
    PUSH AF,DE,HL,IX

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

event_alien_hit_by_player_missile:

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
                             
    LD HL,(IY+_STATE_OFFSET_VAR_0_SPRITE)               ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IY+_STATE_OFFSET_VAR_1_SPRITE)               ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    LD L,utils.TRUE_VALUE                               ; Blanking
    PUSH HL
    
    CALL fast_draw.draw_sprite_16x8
    
    POP DE 
    POP DE
    POP DE

    ; Draw alien explosion
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    LD HL,sprites.ALIEN_EXPLOSION;                      ; Sprite
    PUSH HL

    LD L,utils.FALSE_VALUE                              ; Drawing
    PUSH HL 

    CALL fast_draw.draw_sprite_16x8

    POP HL 
    POP HL
    POP HL

    POP IY,IX,HL

    ; Decrease the count of aliens
    LD A,(_alien_count)
    DEC A
    LD (_alien_count),A

    ; Are we down to the last alien?

    RET

.EXPLODING_ALIEN_DELAY EQU  15



