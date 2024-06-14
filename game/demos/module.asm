    MODULE demos

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "handler.asm"
    INCLUDE "demos.asm"

    MEMORY_USAGE "demo            ",_module_start

    ENDMODULE