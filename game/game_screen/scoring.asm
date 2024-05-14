print_score:
    PUSH HL

    LD HL,(scoring.score)                               ; Grab the current score
    PUSH HL                                             
    LD HL,SCORE_CHAR_COORDS                             ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET