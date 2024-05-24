; The play area is inset slightly to adjust the aspect ration to be as close as we can get to the arcade machine
INSET_X_PIXELS:                 EQU 16
INSET_X_CHARS:                  EQU 2

INSET_SCREEN_WIDTH_CHARS:       EQU draw_common.SCREEN_WIDTH_CHARS-2*INSET_X_CHARS
INSET_SCREEN_WIDTH_PIXELS:      EQU draw_common.SCREEN_WIDTH_PIXELS-2*INSET_X_PIXELS

SCREEN_X_MIDDLE:                EQU (layout.INSET_SCREEN_WIDTH_PIXELS/2)+layout.INSET_X_PIXELS

; Player 1 score
SCORE_PLAYER_1_CHAR_X:          EQU INSET_X_CHARS+3
SCORE_PLAYER_1_CHAR_Y:          EQU 1

SCORE_PLAYER_1_CHAR_COORDS:     EQU (SCORE_PLAYER_1_CHAR_X<<8) + SCORE_PLAYER_1_CHAR_Y

; Player 2 score
SCORE_PLAYER_2_CHAR_X:          EQU INSET_X_CHARS+21
SCORE_PLAYER_2_CHAR_Y:          EQU 1
SCORE_PLAYER_2_CHAR_COORDS:     EQU (SCORE_PLAYER_2_CHAR_X<<8) + SCORE_PLAYER_2_CHAR_Y

; High score
SCORE_HIGH_CHAR_X:              EQU INSET_X_CHARS+11
SCORE_HIGH_CHAR_Y:              EQU 1
SCORE_HIGH_CHAR_COORDS:         EQU (SCORE_HIGH_CHAR_X<<8) + SCORE_HIGH_CHAR_Y

; Shields
SHIELD_WIDTH_PIXELS:            EQU (sprites.SHIELD_DIM_X_BYTES-1)*8

SHIELD_1_X:                     EQU SCREEN_X_MIDDLE-3*SHIELD_WIDTH_PIXELS-SHIELD_WIDTH_PIXELS/2
SHIELD_2_X:                     EQU SCREEN_X_MIDDLE-1*SHIELD_WIDTH_PIXELS-SHIELD_WIDTH_PIXELS/2
SHIELD_3_X:                     EQU SCREEN_X_MIDDLE+1*SHIELD_WIDTH_PIXELS-SHIELD_WIDTH_PIXELS/2
SHIELD_4_X:                     EQU SCREEN_X_MIDDLE+3*SHIELD_WIDTH_PIXELS-SHIELD_WIDTH_PIXELS/2
SHIELD_Y:                       EQU draw_common.SCREEN_HEIGHT_PIXELS-6*8

; Credits
CREDITS_CHAR_X:                 EQU INSET_X_CHARS+25
CREDITS_CHAR_Y:                 EQU draw_common.SCREEN_HEIGHT_CHARS-1
CREDITS_CHAR_COORDS:            EQU (CREDITS_CHAR_X<<8) + CREDITS_CHAR_Y

; Player bases count
PLAYER_COUNT_CHAR_X:            EQU INSET_X_CHARS+1
PLAYER_COUNT_CHAR_Y:            EQU draw_common.SCREEN_HEIGHT_CHARS-1
PLAYER_COUNT_CHAR_COORDS:       EQU (PLAYER_COUNT_CHAR_X<<8) + PLAYER_COUNT_CHAR_Y

; Player base
PLAYER_START_X:                 EQU PLAYER_MIN_X+1  
PLAYER_Y:                       EQU draw_common.SCREEN_HEIGHT_PIXELS-3*8
PLAYER_MIN_X:                   EQU INSET_X_PIXELS+16
PLAYER_MAX_X:                   EQU INSET_X_PIXELS+INSET_SCREEN_WIDTH_PIXELS-(sprites.PLAYER_DIM_X_BYTES-1)*8-16

; Player missile
PLAYER_MISSILE_START_Y:         EQU PLAYER_Y-4 
PLAYER_MISSILE_MIN_Y:           EQU 3*8-4

; Gels
BOTTOM_GEL_TOP_LEFT_Y:          EQU draw_common.SCREEN_HEIGHT_CHARS-6
BOTTOM_GEL_HEIGHT:              EQU 5
BASES_GEL_TOP_LEFT_X:           EQU RESERVE_BASE_START_X/8
BASES_GEL_TOP_LEFT_Y:           EQU draw_common.SCREEN_HEIGHT_CHARS-1
BASES_GEL_WIDTH:                EQU 10
BASES_GEL_HEIGHT:               EQU 1
SPACESHIP_GEL_LEFT_Y:           EQU 2
SPACESHIP_GEL_HEIGHT:           EQU 1

; Reserve bases
RESERVE_BASE_Y:                 EQU draw_common.SCREEN_HEIGHT_PIXELS-8-1
RESERVE_BASE_START_X:           EQU layout.INSET_X_PIXELS+3*8
RESERVE_BASE_OFFSET_X:          EQU ((sprites.PLAYER_DIM_X_BYTES-1)*8)

; Horizonal line towards the bottom of the screen
HORIZONTAL_LINE_Y:              EQU draw_common.SCREEN_HEIGHT_PIXELS-10

; PLAY PLAYER <x> message
PLAY_PLAYER_Y:                  EQU 10
PLAY_PLAYER_X:                  EQU 0
PLAY_PLAYER_COORDS:             EQU (PLAY_PLAYER_X<<8) + PLAY_PLAYER_Y

; Alien missiles
ALIEN_MISSILE_MAX_Y:            EQU draw_common.SCREEN_HEIGHT_PIXELS-2*8-4    ; Y at which missile is considered to have hit the bottom of the screen