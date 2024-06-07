test_splash_screen:
    CALL splash_screen.setup_interrupt_handler
    CALL splash_screen.draw_splash_screen
    CALL splash_screen.draw_controls_screen
    CALL draw_utils.wipe_screen
    RET
