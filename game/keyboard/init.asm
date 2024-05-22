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
    PUSH HL

    LD HL,_fire_already_pressed
    LD (HL),0x00

    IFDEF PAUSEABLE
        LD HL,_pause_already_pressed
        LD (HL),0x00
    ENDIF

    POP HL

    RET