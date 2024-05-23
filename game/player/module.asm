    MODULE player

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "draw.asm"
    INCLUDE "update.asm"
    INCLUDE "events.asm"

    MEMORY_USAGE "player          ",_module_start

    ENDMODULE