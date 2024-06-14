test_demos:
    PUSH HL
    
    LD L,0x00
    PUSH HL
    CALL demos.run_demo
    POP HL

    CALL draw_utils.wipe_screen

    LD L,0x01
    PUSH HL
    CALL demos.run_demo
    POP HL

    CALL draw_utils.wipe_screen

    POP HL

    RET
