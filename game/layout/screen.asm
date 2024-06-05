; The play area is inset slightly to adjust the aspect ration to be as close as we can get to the arcade machine
INSET_X_PIXELS:                 EQU 16
INSET_X_CHARS:                  EQU 2

INSET_SCREEN_WIDTH_CHARS:       EQU draw_common.SCREEN_WIDTH_CHARS-2*INSET_X_CHARS
INSET_SCREEN_WIDTH_PIXELS:      EQU draw_common.SCREEN_WIDTH_PIXELS-2*INSET_X_PIXELS

SCREEN_X_MIDDLE:                EQU (layout.INSET_SCREEN_WIDTH_PIXELS/2)+layout.INSET_X_PIXELS