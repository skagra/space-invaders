    ; ZX Spectrum 48K
    DEVICE ZXSPECTRUM48

    ; Source debugging settings
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    ; Skip past contended memory
    ORG 0x8000 

    INCLUDE "memory_map/module.asm"
    INCLUDE "debug/module.asm"
    INCLUDE "character_set/module.asm"
    INCLUDE "utils/module.asm"
    INCLUDE "screen/module.asm"
    INCLUDE "colours/module.asm"
    INCLUDE "double_buffer/module.asm"
    INCLUDE "draw_utils/module.asm"
    INCLUDE "print/module.asm"

    ; Off-screen buffer
    ORG double_buffer.OFF_SCREEN_BUFFER_START
DRAW_BUFFER:    BLOCK memory_map.SCREEN_SIZE,0x00

    MEMORY_USAGE "double buffer   ", DRAW_BUFFER

    INCLUDE "test_text.asm"

    MODULE main
main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL debug.init
    CALL utils.init
    CALL screen.init
    CALL colours.init
    CALL double_buffer.init
    CALL draw_utils.init
    CALL print.init

    ; Clear the screen
    call draw_utils.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,colours.CA_BG_RED | colours.CA_FG_WHITE
    PUSH HL
    CALL colours.fill_screen_attributes
    POP HL

    CALL test_text

.animation_loop:
    DEBUG_VTRACE_FLASH

    HALT 

    JR .animation_loop          

; Put the stack immediately after the code
STACK_SIZE: EQU 100*2    
STACK_START: BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

    MEMORY_USAGE "stack           ", STACK_START
    
    ENDMODULE

    TOTAL_MEMORY_USAGE

    ; Save snapshot for spectrum emulator
    SAVESNA "bin/tests.sna",main.main


    
