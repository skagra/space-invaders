draw_ready_screen:

    PUSH HL

    LD HL,.PUSH_TEXT
    PUSH HL
    LD HL,.PUSH_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    LD HL,.ONLY_1_PLAYER_TEXT
    PUSH HL
    LD HL,.ONLY_1_PLAYER_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    POP HL
    
    RET

.PUSH_TEXT:                     BYTE "PUSH",0
.PUSH_X:                        EQU 14
.PUSH_Y:                        EQU 9
.PUSH_COORDS:                   EQU (.PUSH_X<<8) + .PUSH_Y

.ONLY_1_PLAYER_TEXT:            BYTE "ONLY 1PLAYER  BUTTON",0
.ONLY_1_PLAYER_X:               EQU 6
.ONLY_1_PLAYER_Y:               EQU 12
.ONLY_1_PLAYER_COORDS:          EQU (.ONLY_1_PLAYER_X<<8) + .ONLY_1_PLAYER_Y



