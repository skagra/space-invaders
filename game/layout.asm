    MODULE layout

_module_start:

INSET_X_PIXELS:             EQU 16
INSET_X_CHARS:              EQU 2

INSET_SCREEN_WIDTH_CHARS:   EQU draw_common.SCREEN_WIDTH_CHARS-2*INSET_X_CHARS
INSET_SCREEN_WIDTH_PIXELS:  EQU draw_common.SCREEN_WIDTH_PIXELS-2*INSET_X_PIXELS

init:
    RET

    MEMORY_USAGE "layout          ",_module_start
    
    ENDMODULE