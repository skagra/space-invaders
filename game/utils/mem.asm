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

.PARAM_FILL_LENGTH:    EQU 12
.PARAM_START_ADDRESS:  EQU 14
.PARAM_FILL_VALUE:     EQU 16

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Grab the stack pointer
    ADD IX,SP

    LD BC,(IX+.PARAM_FILL_LENGTH)                      ; Set up LDIR
    LD HL,(IX+.PARAM_START_ADDRESS)
    LD A,(IX+.PARAM_FILL_VALUE)

    LD (HL),A
    LD E,L
    LD D,H
    INC DE
    DEC BC
    LDIR

    POP  IX,HL,DE,BC,AF
    RET

copy_mem:
.PARAM_SOURCE:  EQU 14
.PARAM_DEST:    EQU 12
.PARAM_COUNT:   EQU 10

    PUSH BC,DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP 

    LD HL,(IX+.PARAM_SOURCE)
    LD DE,(IX+.PARAM_DEST)
    LD BC,(IX+.PARAM_COUNT)

    LDIR

    POP IX,HL,DE,BC
    
    RET