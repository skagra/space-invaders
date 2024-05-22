    MODULE keyboard

_module_start:

    INCLUDE "init.asm"
    INCLUDE "state.asm"
    INCLUDE "keyboard.asm"

    MEMORY_USAGE "keyboard        ",_module_start
    
    ENDMODULE
    