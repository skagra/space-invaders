;------------------------------------------------------------------------------
; Initialise the module
; 
; Usage:
;   CALL init
;------------------------------------------------------------------------------
init:
    RET

;------------------------------------------------------------------------------
; Initialise for a new game
; 
; Usage:
;   CALL new_game
;------------------------------------------------------------------------------

new_game:
    PUSH AF

    LD A,0x00
    LD (_aliens_adjust_index),A

    POP AF

    RET

;------------------------------------------------------------------------------
; Initialise for a new sheet of aliens
; 
; Usage:
;   CALL new_sheet
;------------------------------------------------------------------------------

new_sheet:
    PUSH AF,BC,DE,HL,IX

    ; Alien pack direction
    LD A,_PACK_DIRECTION_RIGHT_VALUE
    LD (_pack_direction),A

    ; Pointer to pack data
    LD HL,_ALIEN_LOOKUP                            
    LD (_current_alien_lookup_ptr),HL

    ; Initial pack variant
    LD A,_ALIEN_VARIANT_0_VALUE
    LD (_current_pack_variant_flag),A        

    ; Pack loop counter
    LD A,_ALIEN_PACK_SIZE
    LD (_pack_loop_counter),A

    ; Allow pack to move
    LD A,utils.TRUE_VALUE
    LD (_alien_pack_moving),A

    ; No alien is exploding
    LD A,utils.FALSE_VALUE
    LD (_alien_is_exploding),A           

    ; Initialise count of aliens
    LD A,_ALIEN_PACK_SIZE
    LD (alien_count),A

    ; Copy the initial alien state over to working copy
    LD HL,_ALIENS_INIT
    PUSH HL
    LD HL,_aliens
    PUSH HL
    LD HL,_ALIENS_SIZE
    PUSH HL
    CALL utils.copy_mem
    POP HL
    POP HL
    POP HL

    ; Get the required pack Y offset 
    LD HL,_ALIENS_ADJUST_FOR_SHEET
    LD D,0x00
    LD A,(_aliens_adjust_index)
    LD E,A
    ADD HL,DE
    LD C,(HL)                               ; Y offset is in C

    ; Alien lookup table
    LD HL,_ALIEN_LOOKUP 

    ; Number of aliens                                      
    LD B,_ALIEN_PACK_SIZE     

    ; Update all aliens with Y offset         
.next_alien:                           
    LD E,(HL)                               ; Pointer to current alien
    INC HL
    LD D,(HL)
    DEC HL

    LD IX,DE
    LD A,(IX+STATE_OFFSET_DRAW_COORDS_Y)    ; Increment Y by required offset
    ADD C
    LD (IX+STATE_OFFSET_DRAW_COORDS_Y),A
    INC HL                                  ; Next alien
    INC HL
    DJNZ .next_alien

    ; If we've run off the end of the list of pack adjustments then reset to the start
    LD A,(_aliens_adjust_index)             
    INC A
    CP _ALIENS_ADJUST_FOR_SHEET_COUNT
    JR NZ,.dont_reset 
    LD A,0x00
    ; Fall through

.dont_reset:
    LD (_aliens_adjust_index),A             ; Store the updated index

    ; Set pack extremities
    LD A,(_aliens+STATE_OFFSET_DRAW_COORDS_Y)
    LD (_pack_bottom),A  

    LD A,(_aliens+STATE_OFFSET_DRAW_COORDS_X)
    LD (_pack_left),A
    
    LD A,(_aliens+((_ALIEN_PACK_SIZE-1)*_AS_SIZE)+STATE_OFFSET_DRAW_COORDS_Y)
    LD (_pack_top),A
    
    LD A,(_aliens+((_ALIEN_PACK_SIZE-1)*_AS_SIZE)+STATE_OFFSET_DRAW_COORDS_X)
    LD (_pack_right),A   

    POP IX,HL,DE,BC,AF

    RET
