    MODULE interrupts

_module_start:

    INCLUDE "init.asm"
    INCLUDE "handler.asm"
    INCLUDE "setup.asm"

    MEMORY_USAGE "interupts       ",_module_start
    
    ENDMODULE
    