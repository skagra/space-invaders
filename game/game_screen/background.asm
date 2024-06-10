set_colours:
    PUSH HL

    ; Most of the screen is white on black
    LD L,colours.CA_BG_BLACK | colours.CA_FG_WHITE
    PUSH HL
    CALL colours.fill_screen_attributes
    POP HL

    ; Green gel to cover active player base and defences
    LD H,layout.BOTTOM_GEL_TOP_LEFT_Y                        ; Top left X
    LD L,layout.BOTTOM_GEL_HEIGHT                            ; Height
    PUSH HL
    LD HL,colours.CA_FG_GREEN                                ; Green fg attribute
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Green gel covering bases showing remaining lives
    LD H,layout.BASES_GEL_TOP_LEFT_X                         ; Top left X
    LD L,layout.BASES_GEL_TOP_LEFT_Y                         ; Top left Y
    PUSH HL
    LD H,layout.BASES_GEL_WIDTH                              ; Width
    LD L,layout.BASES_GEL_HEIGHT                             ; Height
    PUSH HL
    LD HL,colours.CA_FG_GREEN                                ; Green fg attribute
    PUSH HL
    CALL colours.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,layout.SAUCER_GEL_LEFT_Y                           ; Top left X
    LD L,layout.SAUCER_GEL_HEIGHT                           ; Height
    PUSH HL
    LD HL,colours.CA_FG_RED                                  ; Red fg attribute
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    POP HL

    RET

set_border:
    PUSH HL

    ; Set the screen border
    IFNDEF DEBUG
        LD HL,colours.BORDER_BLACK
    ELSE
        LD HL,colours.BORDER_BLUE
    ENDIF
    PUSH HL
    CALL colours.set_border    
    POP HL

    ; For debugging indicate the border section of the screen that is out of bounds
    IFDEF DEBUG
        LD HL,0x0000
        PUSH HL
        LD H,layout.INSET_X_CHARS
        LD L,screen.SCREEN_HEIGHT_CHARS
        PUSH HL
        LD HL,colours.CA_BG_BLUE
        PUSH HL
        CALL colours.fill_screen_attributes_rect
        POP HL
        POP HL
        POP HL

        LD H,screen.SCREEN_WIDTH_CHARS-layout.INSET_X_CHARS
        LD L,0x00
        PUSH HL
        LD H,layout.INSET_X_CHARS
        LD L,screen.SCREEN_HEIGHT_CHARS
        PUSH HL
        LD HL,colours.CA_BG_BLUE
        PUSH HL
        CALL colours.fill_screen_attributes_rect
        POP HL
        POP HL
        POP HL
    ENDIF

    POP HL

    RET