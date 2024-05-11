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

    INCLUDE "memory_map.asm"

    ; Reserve space for screen memory     
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    ; Skip past contended memory
    ORG 0x8000 
    
    INCLUDE "debug.asm"
    INCLUDE "error_codes.asm"
    INCLUDE "utils.asm"
    INCLUDE "draw_common.asm"
    INCLUDE "draw.asm"
    INCLUDE "fast_draw.asm"
    INCLUDE "keyboard.asm"
    INCLUDE "player.asm"
    INCLUDE "player_bullet.asm"
    INCLUDE "alien_pack.asm"
    INCLUDE "print.asm"
    INCLUDE "game_screen.asm"

    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL debug.init
    CALL error_codes.init
    CALL utils.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL player_bullet.init
    CALL alien_pack.init

    ; Draw the initial screen
    CALL game_screen.init_screen
    CALL draw.copy_buffer_to_screen

.animation_loop:
    ; Read keyboard
    CALL keyboard.get_movement_keys

    ; Draw player bullet if there is one
    CALL player_bullet.draw_deferred_bullet

    ; Draw the current alien
    CALL alien_pack.draw_deferred_alien ; problem is we detect the collision here - but we've moved on now to the next alien!  Can we ditch the whole deferred think now we have double buffering

    ; Draw the player base
    CALL player.draw_deferred_player

    ; Calculate new coordinates and handle state changes for the player bullet               
    CALL player_bullet.update_bullet

    ; Calculate new coordinates and variant for current alien
    CALL alien_pack.update_current_alien  

    ; Calcate new coordinates for the player base
    CALL player.update_player

    IFNDEF IGNORE_VSYNC
        ; Wait for Vsync
        HALT 
    ENDIF
    
    ; Copy off screen double buffer to screen memory
    CALL draw.copy_buffer_to_screen
    CALL fast_draw.fast_copy_buffer_to_screen_16x8

    DEBUG_VTRACE_FLASH

    ; Erase the current alien
    CALL alien_pack.blank_current_alien
    
    ; Erase current player bullet
    CALL player_bullet.blank_bullet

    ; Erase player base
    CALL player.blank_player

    ; Move on to next alien
    CALL alien_pack.next_alien

    JP .animation_loop           

    MEMORY_USAGE "main            ", main

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
STACK_START:                BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

    MEMORY_USAGE "stack           ", STACK_START

    ORG 0xC000
DRAW_BUFFER:    BLOCK 0x1800,0x00

    MEMORY_USAGE "double buffer   ", DRAW_BUFFER
    
    ENDMODULE

    INCLUDE "character_set.asm"
    INCLUDE "sprites/all_sprites.asm"

    TOTAL_MEMORY_USAGE
  
    ; Save snapshot for spectrum emulator
    IFDEF DEBUG
        SAVESNA "bin/space-invaders-debug.sna",main.main
    ELSE
        SAVESNA "bin/space-invaders-release.sna",main.main
    ENDIF
   
    
