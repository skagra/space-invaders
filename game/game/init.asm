;------------------------------------------------------------------------------
; Initialise the module
;
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    PUSH AF
    
    LD A,GAME_MODE_PLAY_VALUE
    LD (game_mode),A
    
    POP AF

    RET