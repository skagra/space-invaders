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

    ; Start will the first missile
    LD HL,_current_alien_missile_ptr
    LD DE,_ALIEN_MISSILE_0
    LD (HL),DE

    ; Enable missile firing
    LD A,utils.TRUE_VALUE
    LD (_enabled),A

    POP AF

    RET