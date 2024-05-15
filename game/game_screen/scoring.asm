print_score_player_1:
    PUSH HL

    LD HL,(scoring.score_player_1)                      ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_PLAYER_1_CHAR_COORDS             ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET

print_score_player_2:
    PUSH HL

    LD HL,(scoring.score_player_2)                      ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_PLAYER_2_CHAR_COORDS             ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET

print_score_high:
    PUSH HL

    LD HL,(scoring.score_high)                          ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_HIGH_CHAR_COORDS                 ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET