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

    ; No missile
    LD HL,_missile_state                         
    LD (HL),_MISSILE_STATE_NO_MISSILE

    ; OK to fire (no alien exploding)
    LD HL,_can_fire
    LD (HL),utils.TRUE_VALUE

    POP HL

    RET