event_credit_added:
    PUSH AF
    
    LD A,(credits)
    CP .MAX_CREDITS
    JR Z,.done
    INC A
    DAA
    LD (credits),A
    
.done:
    POP AF

    RET
.MAX_CREDITS: EQU 0x99

event_credit_used:
    PUSH AF
    
    LD A,(credits)
    CP 0x00
    JR Z,.done
    DEC A
    DAA
    LD (credits),A
    
.done:
    POP AF
    
    RET
