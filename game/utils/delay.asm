;------------------------------------------------------------------------------
; Delay loop
;
; Usage:
;   PUSH rr                 ; Length of delay in LSB
;   CALL delay
;   POP rr                  
;------------------------------------------------------------------------------

delay:
    
.PARAM_LEN:    EQU 8

    PUSH BC,DE,IX

    LD  IX,0                                          
    ADD IX,SP

    LD B,(IX+.PARAM_LEN)

.outer_loop:
    LD D,0x08

.mid_loop:
    LD E,0xFF

.inner_loop:
    NOP
    NOP
    NOP
    NOP
    
    DEC E
    JR NZ,.inner_loop

    DEC D
    JR NZ,.mid_loop

    DJNZ .outer_loop

    POP IX,DE,BC

    RET