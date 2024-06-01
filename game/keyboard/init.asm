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

    LD A,utils.FALSE_VALUE
    LD (_fire_already_pressed),A
    LD (_p1_already_pressed),A
    LD (_p2_already_pressed),A
    LD (_creds_already_pressed),A

    IFDEF PAUSEABLE
        LD (_pause_already_pressed),A
    ENDIF

    POP HL

    RET