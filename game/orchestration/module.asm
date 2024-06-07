    MODULE orchestration

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "events.asm"
    INCLUDE "update.asm"

    MEMORY_USAGE "orchestration   ",_module_start
    
    ENDMODULE
    