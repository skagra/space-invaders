    MODULE game_screen

_module_start:

    INCLUDE "init.asm"
    INCLUDE "game_screen.asm"
    INCLUDE "scoring.asm"
    INCLUDE "credits.asm"
    INCLUDE "shields.asm"
    INCLUDE "gels.asm"
    INCLUDE "player_lives.asm"
    INCLUDE "horizontal_line.asm"
    INCLUDE "game_over.asm"
    INCLUDE "intro_screen.asm"
        
    MEMORY_USAGE "game screen     ",_module_start
    
    ENDMODULE