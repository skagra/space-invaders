	MODULE utils

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "utils.asm"
    INCLUDE "graphics.asm"

    MEMORY_USAGE "utils           ",_module_start

	ENDMODULE