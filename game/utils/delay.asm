;------------------------------------------------------------------------------
; Delay loop
;
; Usage:
;   PUSH rr                 ; Length of delay in LSB in refresh cycles
;   CALL delay
;   POP rr                  
;------------------------------------------------------------------------------

delay:
.PARAM_LEN:    EQU 0

    PUSH BC,IX

    PARAMS_IX 2                                         ; Get the stack pointer

    LD B,(IX+.PARAM_LEN)

.delay_loop:
    HALT
    DJNZ .delay_loop

    POP IX,BC

    RET

delay_half_second:
    PUSH BC

    LD C,25
    PUSH BC
    CALL delay
    POP BC

    POP BC
    
    RET

delay_one_second:
    PUSH BC

    LD C,50
    PUSH BC
    CALL delay
    POP BC
    
    POP BC
    
    RET
