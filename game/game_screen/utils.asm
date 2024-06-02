wipe_play_area:
    PUSH HL

    LD L,4
    PUSH HL
    LD L,18
    PUSH HL
    CALL draw_common.wipe_band
    POP HL
    POP HL

    POP HL
    
    RET