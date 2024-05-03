    ; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

    ; Reserve space for screen memory     
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    ; Skip past contended memory
    ORG 0x8000 

    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
    INCLUDE "print.asm"
    INCLUDE "keyboard.asm"
    INCLUDE "game_screen.asm"
    INCLUDE "player.asm"
    INCLUDE "player_bullet.asm"
    INCLUDE "alien_pack.asm"
    INCLUDE "character_set.asm"
    INCLUDE "sprites/all_sprites.asm"

    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL utils.init
    CALL draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL player_bullet.init
    CALL alien_pack.init

    ; Draw the initial screen
    CALL game_screen.init_screen

.animation_loop:
    ; Read keyboard
    CALL keyboard.get_movement_keys

    ; Wait for raster sync
    HALT

    ; Draw the current alien
    CALL alien_pack.draw_deferred_alien

    ; Draw player bullet if there is one
    CALL player_bullet.draw_deferred_bullet

    ; Draw the player base
    CALL player.draw_player

    ; Calculate new coordinates and variant for current alien
    CALL alien_pack.update_current_alien  

    ; Calcate new coordinates for the player base
    CALL player.update_player

    ; Calculate new coordinates and handle state changes for the player bullet               
    CALL player_bullet.update_bullet

    ; Tunable delay to wait until the electron beam is off the bottom of the screen
    LD HL,._DRAW_DELAY
    PUSH HL
    CALL utils.delay
    POP HL

    ; Erase the current alien
    CALL alien_pack.blank_current_alien
    
    ; Erase current player bullet
    CALL player_bullet.blank_bullet

    ; Move on to next alien
    CALL alien_pack.next_alien

    JR .animation_loop           

._DRAW_DELAY: EQU 0x4010

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE
