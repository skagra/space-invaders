    MODULE debug

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "debug.asm"

    MEMORY_USAGE "debug           ",_module_start

    ENDMODULE