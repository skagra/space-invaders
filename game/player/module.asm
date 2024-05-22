    MODULE player

_module_start:

    INCLUDE "init.asm"
    INCLUDE "state.asm"
    INCLUDE "draw.asm"
    INCLUDE "update.asm"

    MEMORY_USAGE "player          ",_module_start

    ENDMODULE