    ; ZX Spectrum 48K
    DEVICE ZXSPECTRUM48

    ; Source debugging settings
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    DISPLAY "Build settings"
    DISPLAY " "

    IFDEF DEBUG
        DISPLAY "DEBUG ENABLED"
    ELSE
        DISPLAY "DEBUG disabled"
    ENDIF

    IFDEF IGNORE_VSYNC
        DISPLAY "IGNORE_VSYNC ENABLED"
    ELSE
        DISPLAY "IGNORE_VSYNC disabled"
    ENDIF

    IFDEF AUTO_FLUSH
        DISPLAY "AUTO_FLUSH ENABLED"
    ELSE
        DISPLAY "AUTO_FLUSH disabled"
    ENDIF

    DISPLAY " "

    INCLUDE "memory_map/module.asm"

    ; Reserve space for screen memory     
    ORG 0x0
    BLOCK memory_map.FREE_MEMORY_START

    ; Skip past contended memory
    ORG 0x8000 
    
    INCLUDE "debug/module.asm"
    INCLUDE "utils/module.asm"
    INCLUDE "global_state/module.asm"
    INCLUDE "draw_common/module.asm"
    INCLUDE "draw/module.asm"
    INCLUDE "fast_draw/module.asm"
    INCLUDE "keyboard/module.asm"
    INCLUDE "player_base/module.asm"
    INCLUDE "player_missile/module.asm"
    INCLUDE "alien_pack/module.asm"
    INCLUDE "print/module.asm"
    INCLUDE "game_screen/module.asm"
    INCLUDE "collision/module.asm"
    INCLUDE "scoring/module.asm"

    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL debug.init
    CALL global_state.init
    CALL utils.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL player_missile.init
    CALL alien_pack.init
    CALL collision.init
    CALL scoring.init

    ; Draw the initial screen
    CALL game_screen.init_screen
    CALL draw.flush_buffer_to_screen

.animation_loop:
    ; Read keyboard
    CALL keyboard.get_movement_keys

    ; Erase player base
    CALL player.blank_player

    ; Calcate new coordinates for the player base
    CALL player.update_player

    ; Draw the player base
    CALL player.draw_player

    ; Erase current player missile
    CALL player_missile.blank_missile

    ; Calculate new coordinates and handle state changes for the player missile               
    CALL player_missile.update_missile

    ; Draw player missile if there is one
    CALL player_missile.draw_player_missile

    ; Handle collisions with player missile 
    CALL collision.handle_collision

    ; Update global state information
    CALL global_state.update_global_state

    ; Erase the current alien
    CALL alien_pack.blank_alien

    ; Calculate new coordinates and variant for current alien  
    CALL alien_pack.update_current_alien  

    ; Draw the current alien
    CALL alien_pack.draw_current_alien 

    ; Move on to next alien
    CALL alien_pack.next_alien

    ; Draw the player's score
    CALL game_screen.print_score

    IFNDEF IGNORE_VSYNC
        ; Wait for Vsync
        HALT 
    ENDIF
    
    ; Copy off screen buffers to screen memory
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8

    DEBUG_VTRACE_FLASH

    JP .animation_loop           

    MEMORY_USAGE "main            ", main

; Put the stack immediately after the code
STACK_SIZE: EQU 100*2    
STACK_START: BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

    MEMORY_USAGE "stack           ", STACK_START

    ORG 0xC000
DRAW_BUFFER:    BLOCK 0x1800,0x00

    MEMORY_USAGE "double buffer   ", DRAW_BUFFER
    
    ENDMODULE

    INCLUDE "character_set/module.asm"
    INCLUDE "sprites/module.asm"

    TOTAL_MEMORY_USAGE
  
    ; Save snapshot for spectrum emulator
    IFDEF DEBUG
        SAVESNA "bin/space-invaders-debug.sna",main.main
    ELSE
        SAVESNA "bin/space-invaders-release.sna",main.main
    ENDIF
   
    
