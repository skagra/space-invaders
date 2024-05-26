event_life_lost:
    PUSH AF,HL

    LD HL,player_lives_1
    LD A,(HL)
    DEC A
    LD (HL),A
    
    POP HL,AF

    RET

