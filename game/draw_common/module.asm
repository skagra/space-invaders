    MODULE draw_common

_module_start:

    INCLUDE "y_mem_row_lookup.asm"
    INCLUDE "screen_dimensions.asm"
    INCLUDE "attributes.asm"
    INCLUDE "draw_common.asm"
    
    MEMORY_USAGE "draw common     ",_module_start

    ENDMODULE