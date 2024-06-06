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

    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL

    RET