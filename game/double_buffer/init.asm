;------------------------------------------------------------------------------
; Initialise the module
;
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    PUSH HL

    LD HL,_BUFFER_STACK
    LD (buffer_stack_top),HL

    POP HL

    RET