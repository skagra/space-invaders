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

    PARAMS_IX 2                                         ; Point IX to the first stack parameter

    LD B,(IX+.PARAM_LEN)                                ; LSB is the length of the delay

.delay_loop:
    HALT                                                ; Wait for VSYNC
    DJNZ .delay_loop                                    ; Reduce delay counter and loop if not zero

    POP IX,BC

    RET

;------------------------------------------------------------------------------
; Delay for half a second
;
; Usage:
;   CALL delay_half_second
;------------------------------------------------------------------------------

delay_half_second:
    PUSH BC

    LD C,25
    PUSH BC
    CALL delay
    POP BC

    POP BC
    
    RET

;------------------------------------------------------------------------------
; Delay for one second
;
; Usage:
;   CALL delay_one_second
;------------------------------------------------------------------------------

delay_one_second:
    PUSH BC

    LD C,50
    PUSH BC
    CALL delay
    POP BC
    
    POP BC
    
    RET
