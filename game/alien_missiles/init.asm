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

    LD A,_ALIEN_MISSILE_TYPE_0
    LD (_current_alien_missile_type),A

    LD HL,_current_alien_missile_ptr
    LD DE,_ALIEN_MISSILE_0
    LD (HL),DE

    POP AF

    RET