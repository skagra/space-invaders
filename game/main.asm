    ; ZX Spectrum 48K
    DEVICE ZXSPECTRUM48

    ; Source debugging settings
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    ; Skip past contended memory
    ORG 0x8000 

    DISPLAY "Build settings"
    DISPLAY " "

    IFDEF DEBUG
        DISPLAY "DEBUG **ENABLED**"
    ELSE
        DISPLAY "DEBUG disabled"
    ENDIF

    IFDEF IGNORE_VSYNC
        DISPLAY "IGNORE_VSYNC **ENABLED**"
    ELSE
        DISPLAY "IGNORE_VSYNC disabled"
    ENDIF

    IFDEF AUTO_FLUSH
        DISPLAY "AUTO_FLUSH **ENABLED**"
    ELSE
        DISPLAY "AUTO_FLUSH disabled"
    ENDIF

    IFDEF DIRECT_DRAW
        DISPLAY "DIRECT_DRAW **ENABLED**"
    ELSE
        DISPLAY "DIRECT_DRAW disabled"
    ENDIF

    IFDEF PAUSEABLE
        DISPLAY "PAUSEABLE **ENABLED**"
    ELSE
        DISPLAY "PAUSEABLE disabled"
    ENDIF

    IFDEF NO_SHIELDS
        DISPLAY "NO_SHIELDS **ENABLED**"
    ELSE
        DISPLAY "NO_SHIELDS disabled"
    ENDIF
    
    DISPLAY " "

    INCLUDE "memory_map/module.asm"
    INCLUDE "debug/module.asm"
    INCLUDE "sprites/module.asm"
    
    ; Off-screen buffer
    ORG draw_common.OFF_SCREEN_BUFFER_START
DRAW_BUFFER:    BLOCK memory_map.SCREEN_SIZE,0x00

    MEMORY_USAGE "double buffer   ", DRAW_BUFFER

    ; Most of the code is after the screen buffer - to allow space for sprites
    INCLUDE "utils/module.asm"
    INCLUDE "layout/module.asm"
    INCLUDE "global_state/module.asm"
    INCLUDE "draw_common/module.asm"
    INCLUDE "draw/module.asm"
    INCLUDE "fast_draw/module.asm"
    INCLUDE "keyboard/module.asm"
    INCLUDE "player/module.asm"
    INCLUDE "player_missile/module.asm"
    INCLUDE "aliens/module.asm"
    INCLUDE "print/module.asm"
    INCLUDE "game_screen/module.asm"
    INCLUDE "collision/module.asm"
    INCLUDE "scoring/module.asm"
    INCLUDE "character_set/module.asm"
    INCLUDE "alien_missiles/module.asm"

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
    CALL layout.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL player_missile.init
    CALL aliens.init
    CALL collision.init
    CALL scoring.init
    CALL alien_missiles.init

    ; Draw the initial screen
    CALL game_screen.draw_pre_play
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8
    CALL game_screen.draw_play
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8

    ; Draw the player's score
    CALL game_screen.print_score_player_1 

.animation_loop:
    ; Reset all collisions
    CALL collision.reset

    ; Read keyboard
    CALL keyboard.get_keys

    ; Erase player base
    CALL player.blank

    ; Erase the current alien
    CALL aliens.blank

    ; Blank current alien missile in cycle 
    CALL alien_missiles.blank

    ; Erase current player missile
    CALL player_missile.blank

    ; Calcate new coordinates for the player base
    CALL player.update

    ; Calculate new coordinates and variant for current alien  
    CALL aliens.update  

    ; Update current alien missile
    CALL alien_missiles.update

    ; Calculate new coordinates and handle state changes for the player missile               
    CALL player_missile.update

    ; Draw the current alien
    CALL aliens.draw

    ; Draw the player base
    CALL player.draw

    ; Draw current alien missile
    CALL alien_missiles.draw

    ; Draw player missile if there is one
    CALL player_missile.draw

    ; Process collisions  
    CALL collision.handle_collision

    ; Update global state information
    CALL global_state.update

    ; Move on to next alien
    CALL aliens.next_alien

    ; Next alien missile
    CALL alien_missiles.next

    IFNDEF IGNORE_VSYNC
        ; Wait for Vsync
        HALT 
    ENDIF
    
    ; Copy off screen buffers to screen memory
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8

    IFDEF PAUSEABLE
.pause_key_down:
        LD A, (keyboard.keys_down)
        BIT keyboard.PAUSE_KEY_DOWN_BIT,A
        JR Z,.pause_key_not_down
.await_pause_key_up:
        CALL keyboard.get_keys
        LD A, (keyboard.keys_down)
        BIT keyboard.PAUSE_KEY_DOWN_BIT,A
        JR NZ,.await_pause_key_up
.await_pause_key_down:
        CALL keyboard.get_keys
        LD A, (keyboard.keys_down)
        BIT keyboard.PAUSE_KEY_DOWN_BIT,A
        JR Z,.await_pause_key_down
.pause_key_not_down:
    ENDIF

    DEBUG_VTRACE_FLASH

    JP .animation_loop           

    MEMORY_USAGE "main            ", main

; Put the stack immediately after the code
STACK_SIZE: EQU 100*2    
STACK_START: BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

    MEMORY_USAGE "stack           ", STACK_START
    
    ENDMODULE

    TOTAL_MEMORY_USAGE
  
    ; Save snapshot for spectrum emulator
    IFDEF DEBUG
        SAVESNA "bin/space-invaders-debug.sna",main.main
;       SAVETAP "bin/space-invaders-debug.tap",main.main
    ELSE
        SAVESNA "bin/space-invaders-release.sna",main.main
;       SAVETAP "bin/space-invaders-release.tap",main.main
    ENDIF
   
    
