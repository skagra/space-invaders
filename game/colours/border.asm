;------------------------------------------------------------------------------
; Set the colour of the screen border
;
; Usage:
;   PUSH rr          ; Colour in LSB
;   CALL set_border
;   POP rr           ; Ditch the supplied parameter
;------------------------------------------------------------------------------

set_border:

.PARAM_BORDER_COLOUR:  EQU 0

    PUSH AF,HL,IX
    
    PARAMS_IX 3                                          ; Get the stack pointer

    LD HL,(IX+.PARAM_BORDER_COLOUR)

    LD A,L
    OUT (0xFE),A
    
    POP IX,HL,AF
    
    RET