    MODULE keyboard

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "read.asm"
    INCLUDE "wait.asm"

    MEMORY_USAGE "keyboard        ",_module_start
    
    ENDMODULE
    