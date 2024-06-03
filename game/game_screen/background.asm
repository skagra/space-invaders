set_colours:
    PUSH HL

    ; Most of the screen is white on black
    LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    ; Green gel to cover active player base and defences
    LD H,layout.BOTTOM_GEL_TOP_LEFT_Y                        ; Top left X
    LD L,layout.BOTTOM_GEL_HEIGHT                            ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_GREEN                       ; Green fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Green gel covering bases showing remaining lives
    LD H,layout.BASES_GEL_TOP_LEFT_X                         ; Top left X
    LD L,layout.BASES_GEL_TOP_LEFT_Y                         ; Top left Y
    PUSH HL
    LD H,layout.BASES_GEL_WIDTH                              ; Width
    LD L,layout.BASES_GEL_HEIGHT                             ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_GREEN                       ; Green fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,layout.SPACESHIP_GEL_LEFT_Y                         ; Top left X
    LD L,layout.SPACESHIP_GEL_HEIGHT                         ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_RED                         ; Red fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attribute_stripe
    POP HL
    POP HL

    POP HL

    RET

set_border:
    PUSH HL

    ; Set the screen border
    IFNDEF DEBUG
        LD HL,draw_common.BORDER_BLACK
    ELSE
        LD HL,draw_common.BORDER_BLUE
    ENDIF
    PUSH HL
    CALL draw_common.set_border    
    POP HL

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