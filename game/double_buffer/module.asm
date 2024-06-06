    MODULE double_buffer

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "flush.asm"

    MEMORY_USAGE "double_buffer   ",_module_start
    
    ENDMODULE