    MODULE double_buffer

init:
    PUSH HL

    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL

    RET

; TODO See if we can successfully use the SP to speed this up
copy_buffer_to_screen:
    PUSH AF,BC,DE,HL

    LD HL,(_buffer_stack_top)

.copy_loop
    LD A, low _BUFFER_STACK
    CP L
    JR NZ,.more
    LD A, high _BUFFER_STACK
    CP H
    JR NZ,.more

    JR .done

.more
    DEC HL                      ; Move to address on the stack
    DEC HL                      ; We do this first as the pointer is the next free address

    LD DE,(HL)                  ; Address in buffer that was written to

    LD A,(DE)                   ; Copy the byte that was written
    LD B,A                      ; Keep a copy in B

    LD A,D                      ; Adjust adress to point to actual screen
    AND 0b00111111              
    OR  0b01000000
    LD D,A

    LD A,B                      ; Copy the buffered byte to the screen
    LD (DE),A

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL,DE,BC,AF
    
    RET

    
_BUFFER_STACK:      BLOCK 1026   
_END_OF_STACK:
_buffer_stack_top:  BLOCK 2             ; This points to the next free location on the stack

check_stack_overflow:
    PUSH AF,DE,HL

    LD DE,_END_OF_STACK
    LD HL,(_buffer_stack_top)
    OR A
    SBC HL,DE
    ADD HL,DE
    JR C, .ok

    DB_FLAG_ERROR error_codes.UB_DOUBLE_BUFFER_STACK_OVERFLOW

.ok:
    POP HL,DE,AF

    RET

    ENDMODULE