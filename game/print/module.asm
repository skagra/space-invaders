    MODULE print

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "print.asm"
    INCLUDE "slow_print.asm"
    INCLUDE "bcd.asm"
    INCLUDE "font.asm"
    
    MEMORY_USAGE "print           ",_module_start

    ENDMODULE