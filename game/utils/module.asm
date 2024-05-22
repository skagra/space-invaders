	MODULE utils

_module_start:

    INCLUDE "init.asm"
    INCLUDE "state.asm"
    INCLUDE "utils.asm"
    INCLUDE "graphics.asm"

    MEMORY_USAGE "utils           ",_module_start

	ENDMODULE