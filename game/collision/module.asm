     MODULE collision

    INCLUDE "../collision_state/state.asm"
_module_start:
    INCLUDE "init.asm"
    INCLUDE "collision.asm"
    
    MEMORY_USAGE "collision       ",_module_start

    ENDMODULE