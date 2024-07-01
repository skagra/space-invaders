    MODULE interrupts

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "setup.asm"

    MEMORY_USAGE "orchestration   ",_module_start
    
    ENDMODULE
    