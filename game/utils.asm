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
    
; usage: PUSH value; PUSH start; PUSH length
fill_mem:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0
    ADD IX,SP
    LD BC,(IX+12)
    LD HL,(IX+14)
    LD A,(IX+16)
    LD (HL),A
    LD E,L
    LD D,H
    INC DE
    DEC BC
    LDIR

    POP  IX,HL,DE,BC,AF
    RET

	ENDMODULE

    MACRO SHIFTR_COUNT_IN_A reg
.start  CP 0x00
        JP Z,.end
        DEC A
        SRL reg
        JP .start       
.end
    ENDM