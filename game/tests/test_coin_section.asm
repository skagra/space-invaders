test_coin_section:
    PUSH HL

    CALL draw_utils.wipe_screen
    
    CALL game.setup_interrupt_handler

    CALL game_screen.print_scores_section
    CALL game_screen.draw_credits_section
    
    LD L,utils.TRUE_VALUE
    PUSH HL
    CALL game_screen.draw_insert_coin_section
    POP HL

    CALL game_screen.play_insert_coin_animation

    POP HL

    RET