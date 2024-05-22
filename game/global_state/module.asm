    MODULE global_state

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "events.asm"
    INCLUDE "update.asm"

    MEMORY_USAGE "global_state    ",_module_start
    
    ENDMODULE
    