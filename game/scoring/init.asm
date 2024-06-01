init:
    PUSH DE,HL

    LD DE,0x0000

    LD HL,score_high
    LD (HL),DE

    CALL new_game

    POP DE,HL
    
    RET

new_game:
    PUSH DE,HL

    LD DE,0x0000

    LD HL,score_player_1
    LD (HL),DE

    LD HL,score_player_2
    LD (HL),DE

    POP DE,HL

    RET