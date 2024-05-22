    MODULE draw_common

_module_start:

    INCLUDE "y_mem_row_lookup.asm"
    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "utils.asm"
    INCLUDE "attributes.asm"
    INCLUDE "border.asm"
    INCLUDE "fills.asm"
    
    MEMORY_USAGE "draw common     ",_module_start

    ENDMODULE