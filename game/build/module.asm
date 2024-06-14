    MODULE build

_module_start:
    INCLUDE "state.asm"
    INCLUDE "show_settings.asm"
    INCLUDE "memory_usage.asm"
    
    MEMORY_USAGE "build           ",_module_start

    ENDMODULE