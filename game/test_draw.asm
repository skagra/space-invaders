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
    INCLUDE "double_buffer.asm"
    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
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
    CALL double_buffer.init
    CALL error_codes.init
    CALL debug.init
    CALL utils.init
    CALL draw.init
    CALL print.init
  
    ; Clear the screen
    call draw.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw.CA_BG_RED | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen_attributes
    POP HL
    
    LD HL,0x1200
    PUSH HL
    LD HL,sprites.sprite_base    
    PUSH HL
    CALL draw.fast_draw_sprite_16x8
    POP HL
    POP HL

    CALL double_buffer.fast_copy_buffer_to_screen_16x8

    LD HL,0x5700
    PUSH HL
    LD HL,sprites.sprite_base    
    PUSH HL
    CALL draw.fast_draw_sprite_16x8
    POP HL
    POP HL

    CALL double_buffer.fast_copy_buffer_to_screen_16x8

.animation_loop:
    DEBUG_VTRACE_FLASH

    HALT 

    JR .animation_loop          

    ORG 0xC000
DRAW_BUFFER:    BLOCK 0x1800,0x00

; Put the stack immediately after the code
STACK_SIZE:                 EQU 100*2    
                            BLOCK STACK_SIZE, 0
STACK_TOP:                  EQU $-1

    ; Save snapshot for spectrum emulator
     SAVESNA "test_draw.sna",main

    ENDMODULE