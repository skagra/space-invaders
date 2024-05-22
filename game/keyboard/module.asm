    MODULE keyboard

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "keyboard.asm"

    MEMORY_USAGE "keyboard        ",_module_start
    
    ENDMODULE
    