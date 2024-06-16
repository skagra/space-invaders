;------------------------------------------------------------------------------
; Initialise the module
;
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    PUSH HL

    LD HL,CHARACTER_SET_SPACE_INVADERS
    PUSH HL
    CALL set_font
    POP HL
    
    POP HL

    RET