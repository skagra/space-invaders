    MODULE game_screen

_module_start:

    INCLUDE "init.asm"
    INCLUDE "scoring.asm"
    INCLUDE "credits.asm"
    INCLUDE "shields.asm"
    INCLUDE "background.asm"
    INCLUDE "player_lives.asm"
    INCLUDE "horizontal_line.asm"
    INCLUDE "game_over.asm"
    INCLUDE "score_table.asm"
    INCLUDE "get_ready.asm"
    INCLUDE "play.asm"
    INCLUDE "push_player_1.asm"
    INCLUDE "utils.asm"
    
    MEMORY_USAGE "game screen     ",_module_start
    
    ENDMODULE