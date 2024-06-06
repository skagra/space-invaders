    MODULE colours

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "border.asm"
    INCLUDE "fills.asm"
    
    MEMORY_USAGE "colours         ",_module_start

    ENDMODULE