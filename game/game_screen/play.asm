draw_play:

    CALL draw_horizontal_line                           ; Line towards the bottom of the screen
    CALL double_buffer.flush_buffer_to_screen
    IFNDEF NO_SHIELDS
        CALL game_screen.draw_shields                   ; Shields
    ENDIF
    CALL double_buffer.flush_buffer_to_screen

    RET