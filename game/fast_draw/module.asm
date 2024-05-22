    MODULE fast_draw

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "draw.asm"

    MEMORY_USAGE "fast draw       ",_module_start

    ENDMODULE