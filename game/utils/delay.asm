;------------------------------------------------------------------------------
; Delay loop
;
; Usage:
;   PUSH rr                 ; Length of delay in LSB in refresh cycles
;   CALL delay
;   POP rr                  
;------------------------------------------------------------------------------

delay:
.PARAM_LEN:    EQU 6
    PUSH BC,IX

    LD  IX,0                                          
    ADD IX,SP

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
