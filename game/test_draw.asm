    ; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

    ; Reserve space for screen memory     
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    ; Skip past contended memory
    ORG 0x8000 

    INCLUDE "error_codes.asm"
    INCLUDE "debug.asm"
    INCLUDE "utils.asm"
    INCLUDE "draw_common.asm"
    INCLUDE "draw.asm"
    INCLUDE "fast_draw.asm"
    INCLUDE "print.asm"
    INCLUDE "character_set.asm"
    INCLUDE "sprites/all_sprites.asm"
    
    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL error_codes.init
    CALL debug.init
    CALL utils.init
    CALL draw_common.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
  
    ; Clear the screen
    call draw.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw.CA_BG_RED | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen_attributes
    POP HL

    ; LD HL,0x1010
    ; PUSH HL
    ; CALL print.inline_print
    ; BYTE "TEST",0
    ; POP HL

    DEBUG_PRINT "TEST"

    LD B, NUM_TEST_SPRITES
    LD HL, TEST_SPRITES

.test_loop
    LD DE,(HL)
    PUSH DE
    INC HL
    INC HL
    LD DE,(HL)   
    PUSH DE
    CALL fast_draw.fast_draw_sprite_16x8
    POP DE
    POP DE
    INC HL
    INC HL

    DJNZ .test_loop

    LD HL, 0x7070
    PUSH HL
    LD HL,sprites.sprite_shield_dims
    PUSH HL
    LD HL,sprites.sprite_shield
    PUSH HL
    CALL draw.draw_sprite
    POP HL
    POP HL
    POP HL

    CALL fast_draw.fast_copy_buffer_to_screen_16x8
    CALL draw.copy_buffer_to_screen

.animation_loop:
    DEBUG_VTRACE_FLASH

    HALT 

    JR .animation_loop          

    ORG 0xC000
DRAW_BUFFER:    BLOCK 0x1800,0x00

TEST_SPRITES:   
    WORD 0x1011, sprites.test_card
    WORD 0x2217, sprites.sprite_alien_1_variant_0
    WORD 0x1053, sprites.sprite_base

NUM_TEST_SPRITES: EQU ($-TEST_SPRITES)/4

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

    ; Save snapshot for spectrum emulator
    SAVESNA "test/test_draw.sna",main

    ENDMODULE

    
