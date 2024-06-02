    MODULE game_screen

_module_start:

    INCLUDE "init.asm"
    INCLUDE "scoring.asm"
    INCLUDE "credits.asm"
    INCLUDE "shields.asm"
    INCLUDE "gels.asm"
    INCLUDE "player_lives.asm"
    INCLUDE "horizontal_line.asm"
    INCLUDE "game_over.asm"
    INCLUDE "intro.asm"
    INCLUDE "get_ready.asm"
    INCLUDE "play.asm"
    INCLUDE "pre_play.asm"
    INCLUDE "ready.asm"
    INCLUDE "utils.asm"
    
    MEMORY_USAGE "game screen     ",_module_start
    
    ENDMODULE