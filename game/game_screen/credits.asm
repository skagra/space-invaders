print_credits:
    PUSH HL

    LD HL,(credits.credits)
    PUSH HL
    LD HL,layout.CREDITS_CHAR_COORDS
    PUSH HL
    CALL print.print_bcd_byte
    POP HL
    POP HL
    
    POP HL

    RET

draw_credits_section:
    PUSH HL

    ; Draw the static text
    LD HL,.CREDS_TEXT
    PUSH HL
    LD HL,.CREDS_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    ; Print credits
    CALL print_credits
    CALL double_buffer.flush_buffer_to_screen

    POP HL

    RET

.CREDS_TEXT:      BYTE "CREDIT",0
.CREDS_X:         EQU 20
.CREDS_Y:         EQU screen.SCREEN_HEIGHT_CHARS-1
.CREDS_COORDS:    EQU (.CREDS_X<<8) + .CREDS_Y