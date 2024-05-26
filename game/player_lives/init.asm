init:
    PUSH AF

    LD A,0x03                       ; TODO
    LD (player_lives_1),A
    
    POP AF
    
    RET