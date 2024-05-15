draw_gels:
    PUSH HL

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
