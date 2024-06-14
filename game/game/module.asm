    MODULE game
_module_start:
    INCLUDE "state.asm"
    INCLUDE "init.asm"
    INCLUDE "screens.asm"
    INCLUDE "main_game_loop.asm"
    INCLUDE "handler.asm"

    MEMORY_USAGE "game            ",_module_start

    ENDMODULE