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
    PUSH AF

    LD A,layout.PLAYER_BASE_START_X
    LD (player_x),A

    POP AF

    RET