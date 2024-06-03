init:
    RET

new_game:
    PUSH AF

    LD A,0x00
    LD (current_sheet),A

    POP AF

    RET
new_sheet:
    PUSH AF,DE,HL

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

    LD A,utils.TRUE_VALUE
    LD (_alien_pack_moving),A

    LD A,utils.FALSE_VALUE
    LD (_alien_is_exploding),A

    ; Pack extremeties
    LD A,(_aliens+_STATE_OFFSET_DRAW_COORDS_Y)
    LD (_pack_bottom),A  

    LD A,(_aliens+_STATE_OFFSET_DRAW_COORDS_X)
    LD (_pack_left),A
    
    LD A,(_aliens+((_ALIEN_PACK_SIZE-1)*_AS_SIZE)+_STATE_OFFSET_DRAW_COORDS_Y)
    LD (_pack_top),A
    
    LD A,(_aliens+((_ALIEN_PACK_SIZE-1)*_AS_SIZE)+_STATE_OFFSET_DRAW_COORDS_X)
    LD (_pack_right),A                      

    LD A,_ALIEN_PACK_SIZE
    LD (alien_count),A

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

    ; Update alien Y position ...

    LD A,(current_sheet)                ; TODO Loop at ?
    INC A
    LD (current_sheet),A

    POP HL,DE,AF

    RET
