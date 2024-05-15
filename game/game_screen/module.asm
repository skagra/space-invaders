    MODULE game_screen

_module_start:

    INCLUDE "game_screen.asm"
    INCLUDE "scoring.asm"
    INCLUDE "credits.asm"
    INCLUDE "player_bases_count.asm"
    INCLUDE "shields.asm"
    INCLUDE "gels.asm"
    INCLUDE "reserve_bases.asm"
    INCLUDE "horizontal_line.asm"
        
    MEMORY_USAGE "game screen     ",_module_start
    
    ENDMODULE