    MODULE interrupts

_module_start:

    INCLUDE "init.asm"
    INCLUDE "handler.asm"
    INCLUDE "setup.asm"

    MEMORY_USAGE "orchestration   ",_module_start
    
    ENDMODULE
    