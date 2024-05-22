init:
    PUSH HL
    
    LD HL,_DRAW_BUFFER_STACK
    LD (_draw_buffer_stack_top),HL
    
    POP HL

    RET