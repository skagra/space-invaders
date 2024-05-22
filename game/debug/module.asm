    MODULE debug

_module_start:

    INCLUDE "init.asm"
    INCLUDE "state.asm"
    INCLUDE "memory_usage.asm"
    INCLUDE "debug.asm"

    MEMORY_USAGE "debug           ",_module_start

    ENDMODULE