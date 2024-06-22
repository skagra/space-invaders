	MODULE utils

_module_start:

    INCLUDE "state.asm"
    INCLUDE "code.asm"
    INCLUDE "init.asm"
    INCLUDE "mem.asm"
    INCLUDE "graphics.asm"
    INCLUDE "delay.asm"
    
    MEMORY_USAGE "utils           ",_module_start

	ENDMODULE