; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

; Reserve space for screen memory and skip over for code start    
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    include "utils.asm"
    include "draw.asm"
    
    MODULE main

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Fill the screen
    LD H,draw.CA_BG_BLACK | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen
    POP HL

    ; Draw some aliens
    
    LD C, 10
cloop:
    LD B, 50
    LD HL, aliens
aloop:
    LD DE, (HL) ; Coords
    PUSH DE

    ; Blank old sprite
    LD DE, sprite_blank
    PUSH DE

    HALT

    CALL draw.draw_sprite
    POP DE
    POP DE

    LD DE, (HL) ; Coords
    INC DE      ; Down one row
    LD (HL), DE  

    PUSH DE     ; New coords
    
    INC HL      ; Skip to sprite data
    INC HL
    LD DE, (HL) ; Sprite
    PUSH DE

    INC HL
    INC HL

    CALL draw.draw_sprite
    POP DE
    POP DE
    DEC B
    JR NZ,aloop

    DEC C
    JR NZ,cloop
forever: JP forever

aliens:         WORD 0x1060,sprite_a_1_0, 0x2060,sprite_a_1_0, 0x3060,sprite_a_1_0, 0x4060,sprite_a_1_0, 0x5060,sprite_a_1_0
                WORD 0x6060,sprite_a_1_0, 0x7060,sprite_a_1_0, 0x8060,sprite_a_1_0, 0x9060,sprite_a_1_0, 0xA060,sprite_a_1_0

                WORD 0x1050,sprite_a_1_0, 0x2050,sprite_a_1_0, 0x3050,sprite_a_1_0, 0x4050,sprite_a_1_0, 0x5050,sprite_a_1_0
                WORD 0x6050,sprite_a_1_0, 0x7050,sprite_a_1_0, 0x8050,sprite_a_1_0, 0x9050,sprite_a_1_0, 0xA050,sprite_a_1_0

                WORD 0x1040,sprite_a_2_0, 0x2040,sprite_a_2_0, 0x3040,sprite_a_2_0, 0x4040,sprite_a_2_0, 0x5040,sprite_a_2_0
                WORD 0x6040,sprite_a_2_0, 0x7040,sprite_a_2_0, 0x8040,sprite_a_2_0, 0x9040,sprite_a_2_0, 0xA040,sprite_a_2_0
                WORD 0x1030,sprite_a_2_0, 0x2030,sprite_a_2_0, 0x3030,sprite_a_2_0, 0x4030,sprite_a_2_0, 0x5030,sprite_a_2_0
                WORD 0x6030,sprite_a_2_0, 0x7030,sprite_a_2_0, 0x8030,sprite_a_2_0, 0x9030,sprite_a_2_0, 0xA030,sprite_a_2_0

                WORD 0x1020,sprite_a_3_0, 0x2020,sprite_a_3_0, 0x3020,sprite_a_3_0, 0x4020,sprite_a_3_0, 0x5020,sprite_a_3_0
                WORD 0x6020,sprite_a_3_0, 0x7020,sprite_a_3_0, 0x8020,sprite_a_3_0, 0x9020,sprite_a_3_0, 0xA020,sprite_a_3_0

sprite_blank:   BYTE 0x02, 0x08
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000    
sprite_a_1_0:   BYTE 0x02, 0x08
                BYTE 0b00000011, 0b11000000
                BYTE 0b00011111, 0b11111000
                BYTE 0b00111111, 0b11111100
                BYTE 0b00111001, 0b10011100
                BYTE 0b00111111, 0b11111100
                BYTE 0b00000110, 0b01100000
                BYTE 0b00001101, 0b10110000
                BYTE 0b00110000, 0b00001100

sprite_a_2_0:   BYTE 0x02, 0x08
                BYTE 0b00000100, 0b00010000
                BYTE 0b00010010, 0b00100100
                BYTE 0b00010111, 0b11110100
                BYTE 0b00011101, 0b11011100
                BYTE 0b00011111, 0b11111100
                BYTE 0b00001111, 0b11111000
                BYTE 0b00000100, 0b00010000
                BYTE 0b00001000, 0b00001000


sprite_a_3_0:   BYTE 0x02, 0x08
                BYTE 0b00000001, 0b10000000
                BYTE 0b00000011, 0b11000000
                BYTE 0b00000111, 0b11100000
                BYTE 0b00001101, 0b10110000
                BYTE 0b00001111, 0b11110000
                BYTE 0b00000010, 0b01000000
                BYTE 0b00000101, 0b10100000
                BYTE 0b00001010, 0b01010000


; Put the stack immediated after the code
; This seems to be needed so the debugger knows where the stack is
STACK_SIZE: EQU 100*2    
            BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE