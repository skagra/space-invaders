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
;
;------------------------------------------------------------------------------

init:
    PUSH AF

    LD HL,_current_alien_missile_ptr
    LD DE,_ALIEN_MISSILE_0
    LD (HL),DE

    LD A,utils.TRUE_VALUE
    LD (_enabled),A

    POP AF

    RET