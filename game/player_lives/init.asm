;------------------------------------------------------------------------------
; Initialize the module
;
; Usage:
;    CALL init
;------------------------------------------------------------------------------

init:
    RET

;------------------------------------------------------------------------------
; Initialize a new game
;
; Usage:
;    CALL new_game
;------------------------------------------------------------------------------

new_game:
    PUSH AF

    LD A,0x03                           ; Set the number of player lives
    LD (player_lives_1),A               ; TODO Move this out into a constant
    
    POP AF
    
    RET