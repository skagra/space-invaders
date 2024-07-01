;------------------------------------------------------------------------------
; Initialise the module
;
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    PUSH HL

    LD A,utils.FALSE_VALUE
    LD (_fire_already_pressed),A
    LD (_p1_already_pressed),A
    LD (_p2_already_pressed),A
    LD (_creds_already_pressed),A
    LD (_space_already_pressed),A

    POP HL

    RET