    MODULE print

_module_start:

    INCLUDE "init.asm"
    INCLUDE "print.asm"
    INCLUDE "slow_print.asm"
    
    MEMORY_USAGE "print           ",_module_start

    ENDMODULE