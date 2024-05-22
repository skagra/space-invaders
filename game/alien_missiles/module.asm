    MODULE alien_missiles

_module_start:

    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "draw.asm"
    INCLUDE "update.asm"
    INCLUDE "events.asm"
        
    MEMORY_USAGE "alien_missiles  ",_module_start
    
    ENDMODULE