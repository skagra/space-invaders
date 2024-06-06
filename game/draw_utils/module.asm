    MODULE draw_utils

_module_start:

    INCLUDE "y_mem_row_lookup.asm"
    INCLUDE "init.asm"
    INCLUDE "coords_to_mem.asm"
    INCLUDE "wipe.asm"
    
    MEMORY_USAGE "draw utils      ",_module_start

    ENDMODULE