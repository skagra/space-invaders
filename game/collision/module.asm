    INCLUDE "../collision_state/partial.asm"
    
    MODULE collision

_module_start:
    INCLUDE "init.asm"
    INCLUDE "collision.asm"
    
    MEMORY_USAGE "collision       ",_module_start

    ENDMODULE