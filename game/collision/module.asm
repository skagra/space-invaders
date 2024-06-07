    MODULE collision
_module_start:
    INCLUDE "../collision_state/state.asm"

    INCLUDE "init.asm"
    INCLUDE "collision.asm"
    
    MEMORY_USAGE "collision       ",_module_start

    ENDMODULE