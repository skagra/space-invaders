
PLAYER_Y:                       EQU screen.SCREEN_HEIGHT_PIXELS-3*8
PLAYER_MIN_X:                   EQU INSET_X_PIXELS+16
PLAYER_MAX_X:                   EQU INSET_X_PIXELS+INSET_SCREEN_WIDTH_PIXELS-(sprites.PLAYER_DIM_X_BYTES-1)*8-16
PLAYER_START_X:                 EQU PLAYER_MIN_X+1  