    MODULE layout

_module_start:

    INCLUDE "alien_missiles.asm"
    INCLUDE "aliens.asm"
    INCLUDE "credits.asm"
    INCLUDE "game_over.asm"
    INCLUDE "horizontal_line.asm"
    INCLUDE "play.asm"
    INCLUDE "player_lives.asm"
    INCLUDE "player_missile.asm"
    INCLUDE "player.asm"
    INCLUDE "scores.asm"
    INCLUDE "screen.asm"
    INCLUDE "shields.asm"
    INCLUDE "gels.asm"
    INCLUDE "saucer.asm"
    INCLUDE "init.asm"
        
    MEMORY_USAGE "layout          ",_module_start
    
    ENDMODULE