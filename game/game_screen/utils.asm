wipe_play_area:
    PUSH HL

    LD L,2
    PUSH HL
    LD L,20
    PUSH HL
    CALL draw_common.wipe_band
    POP HL
    POP HL

    POP HL
    
    RET