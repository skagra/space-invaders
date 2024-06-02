draw_pre_play:
    PUSH HL

    ; Make the screen black until we've drawn some inital content
    IFNDEF DEBUG
        LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_BLACK
    ELSE
        LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_WHITE
    ENDIF
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    ; Set the screen border
    IFNDEF DEBUG
        LD HL,draw_common.BORDER_BLACK
    ELSE
        LD HL,draw_common.BORDER_BLUE
    ENDIF
    PUSH HL
    CALL draw_common.set_border    
    POP HL

    ; Clear the screen
    call game_screen.wipe_play_area

    ; Draw static screen labels
    LD HL,.SCORE_LINE_0_TEXT
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    LD HL,.LIVES_AND_CREDS_TEXT
    PUSH HL
    LD HL,draw_common.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    CALL draw_bases                                     ; Reserved bases
    CALL print_score_high                               ; High score
    CALL print_score_player_1  
    CALL print_credits                                  ; Credits
    CALL print_bases_count                              ; Count of remanining bases
   
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8

    ; Most of the screen is white on black
    LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    ; With some rectangular gels adding limited colour
    CALL draw_gels
    
    ; For debugging indicate the border section of the screen that is out of bounds
    IFDEF DEBUG
        LD HL,0x0000
        PUSH HL
        LD H,layout.INSET_X_CHARS
        LD L,draw_common.SCREEN_HEIGHT_CHARS
        PUSH HL
        LD HL,draw_common.CA_BG_BLUE
        PUSH HL
        CALL draw_common.fill_screen_attributes_rect
        POP HL
        POP HL
        POP HL

        LD H,draw_common.SCREEN_WIDTH_CHARS-layout.INSET_X_CHARS
        LD L,0x00
        PUSH HL
        LD H,layout.INSET_X_CHARS
        LD L,draw_common.SCREEN_HEIGHT_CHARS
        PUSH HL
        LD HL,draw_common.CA_BG_BLUE
        PUSH HL
        CALL draw_common.fill_screen_attributes_rect
        POP HL
        POP HL
        POP HL
    ENDIF

    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8
    
    POP HL

    RET

.SCORE_LINE_0_TEXT:         BYTE "   SCORE<1> HI-SCORE SCORE<2>",0
.LIVES_AND_CREDS_TEXT:      BYTE "                    CREDIT   ",0




