    MODULE aliens

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
    INCLUDE "events.asm"
    INCLUDE "update.asm"
    
    MEMORY_USAGE "aliens          ",_module_start

    ENDMODULE