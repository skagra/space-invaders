draw_intro_screen:
    LD HL,.PLAY_TEXT
    PUSH HL
    LD HL,.PLAY_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.SPACE_INVADERS_TEXT
    PUSH HL
    LD HL,.SPACE_INVADERS_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.SCORE_TABLE_TITLE
    PUSH HL
    LD HL,.SCORE_TABLE_TITLE_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.SAUCER_TEXT
    PUSH HL
    LD HL,.SAUCER_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.ALIEN_TYPE_2_TEXT
    PUSH HL
    LD HL,.ALIEN_TYPE_2_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.ALIEN_TYPE_1_TEXT
    PUSH HL
    LD HL,.ALIEN_TYPE_1_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.ALIEN_TYPE_0_TEXT
    PUSH HL
    LD HL,.ALIEN_TYPE_0_COORDS
    PUSH HL
    CALL print.print_string
    CALL draw.flush_buffer_to_screen
    POP HL
    POP HL

    LD HL,.ALIEN_TYPE_2_SPRITE_COORDS
    PUSH HL
    LD HL,sprites.ALIEN_2_VARIANT_0
    PUSH HL
    LD HL,utils.FALSE_VALUE
    PUSH HL
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL
    POP HL
    CALL fast_draw.flush_buffer_to_screen_16x8

    LD HL,.ALIEN_TYPE_1_SPRITE_COORDS
    PUSH HL
    LD HL,sprites.ALIEN_1_VARIANT_0
    PUSH HL
    LD HL,utils.FALSE_VALUE
    PUSH HL
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL
    POP HL
    CALL fast_draw.flush_buffer_to_screen_16x8

    LD HL,.ALIEN_TYPE_0_SPRITE_COORDS
    PUSH HL
    LD HL,sprites.ALIEN_0_VARIANT_0
    PUSH HL
    LD HL,utils.FALSE_VALUE
    PUSH HL
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL
    POP HL

    CALL fast_draw.flush_buffer_to_screen_16x8

    LD HL,.SAUCER_SPRITE_COORDS
    PUSH HL
    LD HL,sprites.SAUCER_DIMS
    PUSH HL
    LD HL,sprites.SAUCER
    PUSH HL
    LD HL,utils.FALSE_VALUE
    PUSH HL
    LD HL,collision.dummy_collision
    PUSH HL
    
    CALL draw.draw_sprite

    POP HL
    POP HL
    POP HL
    POP HL
    POP HL
    CALL draw.flush_buffer_to_screen

    RET

.PLAY_TEXT:                     BYTE "PLAY",0
.PLAY_X:                        EQU 14
.PLAY_Y:                        EQU 4
.PLAY_COORDS:                   EQU (.PLAY_X<<8) + .PLAY_Y

.SPACE_INVADERS_TEXT:           BYTE "SPACE  INVADERS",0
.SPACE_INVADERS_X:              EQU 9
.SPACE_INVADERS_Y:              EQU 7
.SPACE_INVADERS_COORDS:         EQU (.SPACE_INVADERS_X<<8) + .SPACE_INVADERS_Y

.SCORE_TABLE_TITLE:             BYTE "*SCORE ADVANCE TABLE*",0
.SCORE_TABLE_TITLE_X:           EQU 6
.SCORE_TABLE_TITLE_Y:           EQU 10
.SCORE_TABLE_TITLE_COORDS:      EQU (.SCORE_TABLE_TITLE_X<<8) + .SCORE_TABLE_TITLE_Y

.SAUCER_TEXT:                   BYTE "=? MYSTERY",0
.SAUCER_X:                      EQU 12
.SAUCER_Y:                      EQU 12
.SAUCER_COORDS:                 EQU (.SAUCER_X<<8) + .SAUCER_Y

.ALIEN_TYPE_2_TEXT:             BYTE "=30 POINTS",0
.ALIEN_TYPE_2_X:                EQU 12
.ALIEN_TYPE_2_Y:                EQU 14
.ALIEN_TYPE_2_COORDS:           EQU (.ALIEN_TYPE_2_X<<8) + .ALIEN_TYPE_2_Y

.ALIEN_TYPE_1_TEXT:             BYTE "=20 POINTS",0
.ALIEN_TYPE_1_X:                EQU 12
.ALIEN_TYPE_1_Y:                EQU 16
.ALIEN_TYPE_1_COORDS:           EQU (.ALIEN_TYPE_1_X<<8) + .ALIEN_TYPE_1_Y

.ALIEN_TYPE_0_TEXT:             BYTE "=10 POINTS",0
.ALIEN_TYPE_0_X:                EQU 12
.ALIEN_TYPE_0_Y:                EQU 18
.ALIEN_TYPE_0_COORDS:           EQU (.ALIEN_TYPE_0_X<<8) + .ALIEN_TYPE_0_Y

.SAUCER_SPRITE_X:               EQU ((.SAUCER_X-3)*8)
.SAUCER_SPRITE_Y:               EQU (.SAUCER_Y*8)
.SAUCER_SPRITE_COORDS:          EQU (.SAUCER_SPRITE_X<<8) + .SAUCER_SPRITE_Y

.ALIEN_TYPE_2_SPRITE_X:         EQU ((.ALIEN_TYPE_2_X-2)*8)
.ALIEN_TYPE_2_SPRITE_Y:         EQU (.ALIEN_TYPE_2_Y*8)
.ALIEN_TYPE_2_SPRITE_COORDS:    EQU (.ALIEN_TYPE_2_SPRITE_X<<8) + .ALIEN_TYPE_2_SPRITE_Y

.ALIEN_TYPE_1_SPRITE_X:         EQU ((.ALIEN_TYPE_1_X-2)*8)
.ALIEN_TYPE_1_SPRITE_Y:         EQU (.ALIEN_TYPE_1_Y*8)
.ALIEN_TYPE_1_SPRITE_COORDS:    EQU (.ALIEN_TYPE_1_SPRITE_X<<8) + .ALIEN_TYPE_1_SPRITE_Y

.ALIEN_TYPE_0_SPRITE_X:         EQU ((.ALIEN_TYPE_0_X-2)*8)
.ALIEN_TYPE_0_SPRITE_Y:         EQU (.ALIEN_TYPE_0_Y*8)
.ALIEN_TYPE_0_SPRITE_COORDS:    EQU (.ALIEN_TYPE_0_SPRITE_X<<8) + .ALIEN_TYPE_0_SPRITE_Y






