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

    CALL utils.init
    CALL draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL alien_pack.init

    ; Draw the initial screen
    CALL game_screen.init_screen

animation_loop:
    LD B,alien_pack.ALIEN_PACK_SIZE        ; Alien pack size
    CALL alien_pack.reset_to_pack_start
    CALL alien_pack.adjust_alien_pack_direction

draw_pack_loop:
    CALL player.process_player              ; Read keyboard and modify player position
    CALL alien_pack.move_alien              ; Sets current_alien_new_coords
    
    ; Set up parameters for wiping old alien and drawing new
    LD HL,(alien_pack.current_alien_ptr)    ; Old coords
    LD DE,(HL)
    PUSH DE                                 ; Push old coords
    LD DE,(current_alien_new_coords)        ; Push new coords 
    PUSH DE

    ; Skip to pointer to pointer to first sprite variant data
    INC HL                                  
    INC HL

    ; Select sprite variant - keyed off C the alien loop counter
    PUSH BC                                 ; Push variant determinant
    PUSH HL                                 ; Push pointer to pointer to first variant sprite data
    PUSH HL                                 ; Make some space for the return value
    CALL alien_pack.select_sprite_variant
    POP DE                                  ; Return value pop pointer to selected variant sprite data
    POP HL                                  ; Pop param - pointer to pointer to first variant 
    POP HL                                  ; Pop param - variant determinant
    PUSH DE                                 ; Push pointer to sprite data to use

    ; Overwrite the old alien coords with the new ones
    LD HL,(alien_pack.current_alien_ptr)               
    LD DE,(current_alien_new_coords)
    LD (HL),DE

    ; Move ptr to next alien in the pack
    LD DE,0x06                              
    ADD HL,DE
    LD (alien_pack.current_alien_ptr),HL

    ; Wait for raster sync
    HALT

    ; Draw the current alien
    CALL alien_pack.draw_alien
    POP HL                                  ; Ditch sprite data param
    POP HL                                  ; Ditch new coords param
    POP HL                                  ; Ditch old coords param

    ; Draw the player base
    CALL player.draw_player

    ; More aliens to draw?
    DEC B
    JP NZ,draw_pack_loop

    ; More animations cycles to complete?
    DEC C                                   
    ;JP NZ,animation_loop     
    JP animation_loop               

forever: JP forever

current_alien_new_coords:   BLOCK 2

; Put the stack immediately after the code
STACK_SIZE: EQU 100*2    
            BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE
