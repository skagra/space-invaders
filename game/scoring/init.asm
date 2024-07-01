;------------------------------------------------------------------------------
; Initialize the module
; 
; Usage:
;   CALL init
;------------------------------------------------------------------------------

init:
    PUSH DE,HL

    LD DE,0x0000                ; Set high score to zero
    LD HL,score_high            
    LD (HL),DE

    POP DE,HL
    
    RET

;------------------------------------------------------------------------------
; Start a new game
; 
; Usage:
;   CALL new_game
;------------------------------------------------------------------------------

new_game:
    PUSH DE,HL

    LD DE,0x0000

    LD HL,score_player_1        ; Set high player 1 score to zero
    LD (HL),DE

    LD HL,score_player_2        ; Set high player 2 score to zero
    LD (HL),DE

    POP DE,HL

    RET