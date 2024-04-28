	MODULE utils

;------------------------------------------------------------------------------
;
; Initialise the module
;
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

init:
    RET
    
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

    LD  IX,0                            ; Grab the stack pointer
    ADD IX,SP

    LD BC,(IX+._PARAM_FILL_LENGTH)      ; Set up LDIR
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

delay:

._PARAM_LOOPS:  EQU 8

    PUSH BC,DE,IX

    LD  IX,0                            ; Grab the stack pointer
    ADD IX,SP

    LD DE,(IX+._PARAM_LOOPS)            ; Size of each loop

    LD B,D                              ; Outer loop counter

.outer_loop
    LD C,E                              ; Inner loop counter

.inner_loop
    DEC C
    JR NZ, .inner_loop

    DEC B
    JR NZ, .outer_loop

    POP IX,DE,BC

    RET

	ENDMODULE
