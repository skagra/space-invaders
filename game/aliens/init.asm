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

    ; LD A,utils.FALSE_VALUE
    ; LD (_pack_halted),A

    LD A,_ALIEN_PACK_STATE_ACTIVE_VALUE
    LD (_alien_pack_state),A

    ; Pack extremeties
    ; TODO We need a proper way of setting initial values (perhaps they can just be set to their opposite min/max's)
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