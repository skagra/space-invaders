    MODULE draw

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "draw.asm"

    MEMORY_USAGE "draw            ",_module_start
    
    ENDMODULE