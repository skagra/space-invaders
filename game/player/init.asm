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
    PUSH AF,DE,HL

    LD A,layout.PLAYER_START_X
    LD (player_x),A

    LD A,_PLAYER_STATE_ACTIVE_VALUE
    LD (player_state),A

    ; LD A,0x00
    ; LD (_player_explosion_current_variant_toggle),A

    ; LD DE,sprites.PLAYER_EXPLOSION_VARIANT_0
    ; LD HL,_player_explosion_current_variant_sprite
    ; LD (HL),DE

    POP HL,DE,AF

    RET