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

    LD A,_ALIEN_MISSILES_GLOBAL_STATE_ACTIVE_VALUE
    LD (_alien_missiles_global_state),A

    POP AF

    RET