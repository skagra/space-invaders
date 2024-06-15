;------------------------------------------------------------------------------
; Set the colour of the screen border
;
; Usage:
;   PUSH rr          ; Colour in LSB
;   CALL set_border
;   POP rr           ; Ditch the supplied parameter
;------------------------------------------------------------------------------

set_border:
.PARAM_BORDER_COLOUR:  EQU 8

    PUSH AF,HL,IX
    
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_BORDER_COLOUR)

    LD A,L
    OUT (0xFE),A
    
    POP IX,HL,AF
    
    RET