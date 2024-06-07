    MODULE game
_module_start:
    INCLUDE "main_game_loop.asm"
    INCLUDE "handler.asm"

    MEMORY_USAGE "game            ",_module_start

    ENDMODULE