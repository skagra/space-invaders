    ; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map/module.asm"

    ; Reserve space for screen memory     
    ORG 0x0
    BLOCK memory_map.FREE_MEMORY_START

    ; Skip past contended memory
    ORG 0x8000 

    INCLUDE "debug/module.asm"
    INCLUDE "utils/module.asm"
    INCLUDE "draw_common/module.asm"
    INCLUDE "draw/module.asm"
    INCLUDE "fast_draw/module.asm"
    INCLUDE "print/module.asm"
    INCLUDE "character_set/module.asm"
    INCLUDE "sprites/module.asm"
    INCLUDE "scoring/module.asm"
    INCLUDE "alien_missiles/module.asm"
    INCLUDE "collision/module.asm"
    INCLUDE "alien_pack/module.asm"
    INCLUDE "global_state/module.asm"
    INCLUDE "layout/module.asm"
    INCLUDE "player_missile/module.asm"
    INCLUDE "keyboard/module.asm"
    INCLUDE "player_base/module.asm"

    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL debug.init
    CALL utils.init
    CALL draw_common.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL scoring.init
    CALL alien_missiles.init
    CALL collision.init
    CALL alien_pack.init
    CALL global_state.init
    CALL layout.init
    CALL player_missile.init
    CALL keyboard.init
    CALL player.init

    ; Clear the screen
    call draw_common.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw_common.CA_BG_RED | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    LD B, NUM_TEST_SPRITES
    LD HL, TEST_SPRITES

    CALL alien_missiles.draw
    CALL draw.flush_buffer_to_screen

    DEBUG_PRINT "A TEST"

.test_loop
    LD DE,(HL)
    PUSH DE
    INC HL
    INC HL
    LD DE,(HL)   
    PUSH DE

    LD E,utils.FALSE_VALUE
    PUSH DE 

    CALL fast_draw.draw_sprite_16x8
    
    POP DE 
    POP DE
    POP DE
    INC HL
    INC HL

    DJNZ .test_loop

    LD HL, 0x7070
    PUSH HL
    
    LD HL,sprites.SHIELD_DIMS
    PUSH HL
    
    LD HL,sprites.SHIELD
    PUSH HL

    LD L, utils.FALSE_VALUE
    PUSH HL
    
    LD HL,collision.dummy_collision
    PUSH HL

    CALL draw.draw_sprite
    
    POP HL 
    POP HL
    POP HL
    POP HL
    POP HL

    LD HL,0x0000
    PUSH HL
    LD HL,0x1010
    PUSH HL
    CALL print.print_bcd_word
    POP HL
    POP HL

    HALT 

    CALL fast_draw.flush_buffer_to_screen_16x8
    CALL draw.flush_buffer_to_screen

.animation_loop:
    DEBUG_VTRACE_FLASH

    HALT 

    JR .animation_loop          

    ORG 0xC000
DRAW_BUFFER:    BLOCK 0x1800,0x00

TEST_SPRITES:   
    WORD 0x3050, sprites.TEST_CARD
    WORD 0x4088, sprites.ALIEN_1_VARIANT_0
    WORD 0x1053, sprites.PLAYER

NUM_TEST_SPRITES: EQU ($-TEST_SPRITES)/4

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

    ; Save snapshot for spectrum emulator
    SAVESNA "bin/test_draw.sna",main

    ENDMODULE

    
