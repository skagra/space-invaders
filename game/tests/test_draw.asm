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
  
    ; Clear the screen
    call draw_common.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw_common.CA_BG_RED | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    LD B, NUM_TEST_SPRITES
    LD HL, TEST_SPRITES

.test_loop
   ; DEBUG_PRINT "A TEST"

    LD DE,(HL)
    PUSH DE
    INC HL
    INC HL
    LD DE,(HL)   
    PUSH DE

    LD E,utils.FALSE_VALUE
    PUSH DE ; xxx
    CALL fast_draw.draw_sprite_16x8
    POP DE ; xxx
    
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
    PUSH HL ; xxx
    CALL draw.draw_sprite
    POP HL ; xxx 
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

    ; LD HL,0x1234
    ; LD (scoring.score),HL
    ; LD HL,0x1182
    ; PUSH HL
    ; CALL scoring.add_to_score
    ; POP HL

    ; LD HL,(scoring.score)
    ; PUSH HL
    ; LD HL,0x100A
    ; PUSH HL
    ; CALL print.print_bcd_word
    ; POP HL
    ; POP HL

    ; CALL scoring.print_score

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
    WORD 0x1053, sprites.PLAYER_BASE

NUM_TEST_SPRITES: EQU ($-TEST_SPRITES)/4

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

    ; Save snapshot for spectrum emulator
    SAVESNA "bin/test_draw.sna",main

    ENDMODULE

    
