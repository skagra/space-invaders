;------------------------------------------------------------------------------
; Fill an area of memory with a given value
;
; Usage:
;   PUSH rr                 ; Fill value in LSB
;   PUSH rr                 ; Start address
;   PUSH rr                 ; Fill length
;   CALL fill_mem
;   POP rr,rr,rr
;------------------------------------------------------------------------------

fill_mem:

.PARAM_FILL_VALUE:     EQU 4
.PARAM_START_ADDRESS:  EQU 2
.PARAM_FILL_LENGTH:    EQU 0

    PUSH AF,BC,DE,HL,IX

    PARAMS_IX 5                                         ; Get the stack pointer

    LD BC,(IX+.PARAM_FILL_LENGTH)                       ; Set up LDIR
    LD HL,(IX+.PARAM_START_ADDRESS)
    LD A,(IX+.PARAM_FILL_VALUE)

    LD (HL),A                                           ; Write the first byte
    LD E,L                                              ; Set DE to point to second dest byte
    LD D,H
    INC DE                                              ; Move dest to second byte
    DEC BC                                              ; One byte written - so decrease count

    LDIR                                                ; Fill (copy) the given value over dest area of memory

    POP  IX,HL,DE,BC,AF
    RET

;------------------------------------------------------------------------------
;
; Copy an area of memory 
;
; Usage:
;   PUSH rr                 ; Source address
;   PUSH rr                 ; Destination address
;   PUSH rr                 ; Number of bytes to copy
;   CALL copy_mem
;   POP rr,rr,rr
;
;------------------------------------------------------------------------------

copy_mem:

.PARAM_SOURCE:  EQU 4
.PARAM_DEST:    EQU 2
.PARAM_COUNT:   EQU 0

    PUSH BC,DE,HL,IX

    PARAMS_IX 4                                         ; Get the stack pointer

    LD HL,(IX+.PARAM_SOURCE)                            ; Set up LDIR
    LD DE,(IX+.PARAM_DEST)
    LD BC,(IX+.PARAM_COUNT)

    LDIR                                                ; Copy

    POP IX,HL,DE,BC
    
    RET