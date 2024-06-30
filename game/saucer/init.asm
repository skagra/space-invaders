init:
    RET

new_sheet:
    PUSH AF,HL

    LD A,_SAUCER_STATE_NO_SAUCER_VALUE
    LD (_saucer_state),A

    LD A,utils.FALSE_VALUE
    LD (enabled),A
    LD (timer_enabled),A

    LD HL,0x0000
    LD (_saucer_timer),HL

    POP HL,AF
    
    RET