;------------------------------------------------------------------------------
;
; Initialise the module
;
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------
init:
    RET
    
;------------------------------------------------------------------------------
;
; Draw the initial screen.
; 
; Usage:
;   CALL init_screen
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

draw:
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
    call draw_common.wipe_screen

    ; Draw static screen labels
    LD HL,._SCORE_LINE_0_TEXT
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,._LIVES_AND_CREDS_TEXT
    PUSH HL
    LD HL,draw_common.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    CALL draw_horizontal_line                           ; Line towards the bottom of the screen
    CALL draw_reserve_bases                             ; Reserved bases
    CALL game_screen.print_score_high                   ; High score
    CALL game_screen.print_score_player_1               ; Player 1 score
    CALL game_screen.print_score_player_2               ; Player 2 score
    CALL game_screen.print_credits                      ; Credits
    CALL game_screen.print_player_bases_count           ; Count of remanining bases
    CALL game_screen.draw_shields                       ; Shields

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

    POP HL

    RET

._SCORE_LINE_0_TEXT:        BYTE "   SCORE<1> HI-SCORE SCORE<2>",0
._LIVES_AND_CREDS_TEXT:     BYTE "                    CREDIT   ",0

