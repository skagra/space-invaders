;------------------------------------------------------------------------------
;
; Fill an area of memory with a given value
;
; Usage:
;   PUSH rr                 ; Fill value in LSB
;   PUSH rr                 ; Start address
;   PUSH rr                 ; Fill length
;
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

fill_mem:

._PARAM_FILL_LENGTH:    EQU 12
._PARAM_START_ADDRESS:  EQU 14
._PARAM_FILL_VALUE:     EQU 16

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Grab the stack pointer
    ADD IX,SP

    LD BC,(IX+._PARAM_FILL_LENGTH)                      ; Set up LDIR
    LD HL,(IX+._PARAM_START_ADDRESS)
    LD A,(IX+._PARAM_FILL_VALUE)

    LD (HL),A
    LD E,L
    LD D,H
    INC DE
    DEC BC
    LDIR

    POP  IX,HL,DE,BC,AF
    RET

