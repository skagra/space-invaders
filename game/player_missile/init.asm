;------------------------------------------------------------------------------
; Initialise the module
;
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    RET

new_sheet:
    PUSH AF,HL

    ; No missile
    LD HL,_missile_state                         
    LD (HL),_MISSILE_STATE_NO_MISSILE_VALUE

    ; OK to fire (no alien exploding)
    LD HL,_can_fire
    LD (HL),utils.TRUE_VALUE

    ; Initialize the shot counter
    LD A,0x00
    LD (shot_count),A

    POP HL,AF

    RET
    