    ; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

    ; Reserve space for screen memory and skip over for code start    
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START
    
    ;---
    ; Skip ULA contended memory? 
    ; https://worldofspectrum.org/faq/reference/48kreference.htm
    ; Check this
    ORG 0x8000 
    ;---

    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
    INCLUDE "print.asm"
    INCLUDE "keyboard.asm"
    INCLUDE "game_screen.asm"
    INCLUDE "player.asm"
    INCLUDE "alien_pack.asm"
    INCLUDE "processed_sprites/all_sprites.asm"

    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Count of animation cycles
    LD C, 0xFF

    ; Initialise all modules
    CALL utils.init
    CALL draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL alien_pack.init

    ; Draw the initial screen
    CALL game_screen.init_screen

.animation_loop:
    LD B,alien_pack._ALIEN_PACK_SIZE             ; Alien pack size counter for drawing aliens
   
.draw_pack_loop:
    CALL player.update_player                   ; Read keyboard and modify player position
    CALL alien_pack.update_current_alien        ; Sets current_alien_new_coords

    ; Wait for raster sync
    HALT

    ; Draw the current alien
    CALL alien_pack.draw_current_alien

    ; Draw the player base
    CALL player.draw_player

    ; Move on to next alien
    CALL alien_pack.next_alien

    ; More aliens to draw?
    DEC B
    JP NZ,.draw_pack_loop

    ; Reset to start of pack
    CALL alien_pack.next_pack_cycle

    ; More animations cycles to complete?
    DEC C                                   
    ;JP NZ,animation_loop     
    JP .animation_loop               

.forever: JP .forever

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE
