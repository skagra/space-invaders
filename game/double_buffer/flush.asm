flush_buffer_to_screen:
    IFDEF DIRECT_DRAW                                   ; Nothing to do if DIRECT_DRAW is enabled
        RET
    ENDIF

    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (.stack_stash),SP                                ; Store current SP to restore at end

    LD SP,_BUFFER_STACK                                 ; Subtract start of stack area (low mem)
    LD HL,(_buffer_stack_top)                           ; from current stack pointer (first free byte)
    LD A,L
    SUB low _BUFFER_STACK
    LD L,A
    LD A,H
    SBC high _BUFFER_STACK
    LD H,A
     
    SRL H                                               ; Divide the result by two to give number of loops to run
    RR L                                                ; as we are dealing with word chunks on the stack

.copy_loop
    LD A,H                                              ; Is the copy counter zero?
    OR L
    JP Z,.done                                          ; Yes - done

    DEC HL                                              ; No - decrease the counter

.more
    POP DE                                              ; Get the address written to in the off screen buffer

    LD A,(DE)                                           ; Copy the byte that was written
    RES 7,D
    LD (DE),A

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK                                 ; Reset the stack
    LD (_buffer_stack_top),HL
    
    LD SP,(.stack_stash)                                ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

.stack_stash: BLOCK 2