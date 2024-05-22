    MODULE debug

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "memory_usage.asm"
    INCLUDE "debug.asm"

    MEMORY_USAGE "debug           ",_module_start

    ENDMODULE