draw_get_ready:
    PUSH HL

    LD HL,.PLAY_PLAYER_1_TEXT
    PUSH HL
    LD HL,10                                            ; TODO Pull out hard coded value
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    CALL flash_score_player_1
    CALL print_score_player_1
    CALL draw.flush_buffer_to_screen
    
    LD HL,.PLAY_PLAYER_1_BLANK
    PUSH HL
    LD HL,layout.PLAY_PLAYER_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    CALL draw.flush_buffer_to_screen

    POP HL

    RET
.PLAY_PLAYER_1_TEXT:        BYTE "         PLAY PLAYER<1>      ",0
.PLAY_PLAYER_1_BLANK:       BYTE "                             ",0
