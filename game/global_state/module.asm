    MODULE global_state

_module_start:

    INCLUDE "init.asm"
    INCLUDE "state.asm"
    INCLUDE "events.asm"
    INCLUDE "update.asm"

    MEMORY_USAGE "global_state    ",_module_start
    
    ENDMODULE
    