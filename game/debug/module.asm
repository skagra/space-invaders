    MODULE debug

_module_start:

    INCLUDE "memory_usage.asm"
    INCLUDE "debug.asm"

    MEMORY_USAGE "debug           ",_module_start

    ENDMODULE