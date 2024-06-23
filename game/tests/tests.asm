    ; ZX Spectrum 48K
    DEVICE ZXSPECTRUM48

    ; Source debugging settings
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    ; Contended memory 
    ORG memory_map.FREE_MEMORY_START
    INCLUDE "memory_map/module.asm"
    INCLUDE "build/module.asm"
    INCLUDE "utils/module.asm"
    INCLUDE "debug/module.asm"
    INCLUDE "screen/module.asm"
    INCLUDE "splash_screen/module.asm"
    INCLUDE "colours/module.asm"

    ; Skip past contended memory
    ORG memory_map.UNCONTENDED_MEMORY_START

    INCLUDE "sprites/module.asm"
    INCLUDE "character_set/module.asm"
    INCLUDE "double_buffer/module.asm"
    INCLUDE "draw_utils/module.asm"
    INCLUDE "draw/module.asm"
    INCLUDE "fast_draw/module.asm"
    INCLUDE "keyboard/module.asm"
    INCLUDE "print/module.asm"
    INCLUDE "layout/module.asm"

    ; Off-screen buffer
    ORG double_buffer.OFF_SCREEN_BUFFER_START
DRAW_BUFFER:    BLOCK memory_map.SCREEN_SIZE,0x00

    MEMORY_USAGE "off-screen buffer ", DRAW_BUFFER

    INCLUDE "saucer/module.asm"
    INCLUDE "orchestration/module.asm"
    INCLUDE "player/module.asm"
    INCLUDE "player_missile/module.asm"
    INCLUDE "aliens/module.asm"
    INCLUDE "game_screen/module.asm"
    INCLUDE "collision/module.asm"
    INCLUDE "scoring/module.asm"
    INCLUDE "alien_missiles/module.asm"
    INCLUDE "player_lives/module.asm"
    INCLUDE "credits/module.asm"
    INCLUDE "interrupts/module.asm"
    INCLUDE "game/module.asm"
    INCLUDE "demos/module.asm"

    ; Tests
    INCLUDE "test_splash_screen.asm"
    INCLUDE "test_demos.asm"
    INCLUDE "test_coin_section.asm"

    MACRO RUN_TEST name
        CALL name
        LD L,keyboard.PAUSE_KEY_DOWN_MASK
        PUSH HL
        CALL keyboard.wait
        POP HL
        call draw_utils.wipe_screen
    ENDM

    MODULE main
main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    CALL debug.init
    CALL orchestration.init
    CALL utils.init
    CALL layout.init
    CALL screen.init
    CALL colours.init
    CALL double_buffer.init
    CALL draw_utils.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL saucer.init
    CALL player.init
    CALL player_missile.init
    CALL aliens.init
    CALL collision.init
    CALL scoring.init
    CALL alien_missiles.init
    CALL player_lives.init
    CALL credits.init
    CALL interrupts.init
    CALL game.init

    ; Set up interrupt handling vector
    CALL interrupts.setup

    ; Clear the screen
    call draw_utils.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,colours.CA_BG_RED | colours.CA_FG_WHITE
    PUSH HL
    CALL colours.fill_screen_attributes
    POP HL

    ; Tests
    IFDEF TEST_SPLASH_SCREEN
        RUN_TEST test_splash_screen
    ENDIF

    IFDEF TEST_DEMOS
        RUN_TEST test_demos
    ENDIF

    IFDEF TEST_COIN_SECTION
        RUN_TEST test_coin_section
    ENDIF

.animation_loop:
    DEBUG_VTRACE_FLASH 

    HALT 

    JR .animation_loop          

; Put the stack immediately after the code
STACK_SIZE:     EQU 100*2    
STACK_START:    BLOCK STACK_SIZE, 0
STACK_TOP:      EQU $-1

    MEMORY_USAGE "stack           ", STACK_START
    
    ENDMODULE

    ORG interrupts.INTERRUPT_JUMP
    BLOCK 3
    MEMORY_USAGE "interrupt jump   ",interrupts.INTERRUPT_JUMP

    ORG interrupts.INTERRUPT_VECTOR_TABLE
    BLOCK 257
    MEMORY_USAGE "interrupt vector ",interrupts.INTERRUPT_VECTOR_TABLE

    TOTAL_MEMORY_USAGE

    ; Save snapshot for spectrum emulator
    SAVESNA "bin/tests.sna",main.main       ; sna48-ok


    
