    MODULE scoring

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "scoring.asm"
    INCLUDE "events.asm"

    MEMORY_USAGE "scoring         ",_module_start

    ENDMODULE