; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

; Reserve space for screen memory and skip over for code start    
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
    
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
    LD C, 22

    ; Start going right
    LD A,DIRECTION_RIGHT
    LD (direction),A
animation_loop:
    LD B,50
    LD HL,aliens

    LD A,C
    AND 0b00000011
    CP 0b00000010
    JR NZ, notdown

    LD A,(direction)    
    CP DIRECTION_RIGHT
    JR Z,switch_to_left
    LD A,DIRECTION_RIGHT
    LD (direction),A
    JR switched_to_right
switch_to_left:
    LD A,DIRECTION_LEFT
    LD (direction),A
switched_to_right:

notdown:

draw_pack_loop:
    ; Wait for screen blank
    HALT

    ; LD HL,0x2130
    ; PUSH HL
    ; LD HL,sprite_a_1_0
    ; PUSH HL
    ; CALL draw.draw_sprite
    ; POP HL
    ; POP HL

    ; LD HL,0x2440
    ; PUSH HL
    ; LD HL,sprite_a_1_0
    ; PUSH HL
    ; CALL draw.draw_sprite
    ; POP HL
    ; POP HL

    ; Blank old sprite
    ; LD DE,(HL)             ; Coords of current alien
    ; PUSH DE     
    ; LD DE,sprite_blank     ; Background square
    ; PUSH DE
    ; LD DE,mask_2_16
    ; PUSH DE
    ; CALL draw.draw_sprite
    ; POP DE
    ; POP DE
    ; POP DE

    ; Move sprite to new position
    LD DE,(HL)              ; Coords
    LD A,C
    AND 0b00000011
    CP 0b00000010
    JR Z, down

    ; Sideways movement
    LD A,(direction)
    CP DIRECTION_RIGHT
    JR Z,going_right
    DEC D
    DEC D
    JR gone_left
going_right:
    INC D
    INC D
gone_left:
    JR moved
down:
    INC DE                 ; Down 2 rows
    INC DE

moved:
    LD (HL),DE              ; Overwrite old coords with new
    PUSH DE                 ; New coords
    
    INC HL                  ; Skip to pointer to sprite data
    INC HL

    BIT 0,C                 ; Which variant of sprite to draw
    JR Z,variant_2
    INC HL                  ; Skip to second variant of sprite
    INC HL
variant_2:    
    LD DE,(HL)              ; Sprite data pointer of alien
    PUSH DE

    INC HL                  ; Skip past the sprite pointer
    INC HL

    BIT 0,C                 ; If we selected the first variant then skip past the second variant pointer
    JR NZ,variant_1
    INC HL
    INC HL
variant_1:
    LD DE,mask_2_16
    PUSH DE
    CALL draw.draw_sprite   ; Draw the alien sprite
    POP DE                  ; Remove parameters from stack
    POP DE
    POP DE
    DEC B                   ; One more alien has been done, dec loop counter
    JR NZ,draw_pack_loop    ; Done drawing sheet of aliens?

    DEC C                   ; One more cycle of animating pack done
    JR NZ,animation_loop    ; Done animating?

forever: JP forever

; Data
    INCLUDE "sprite_data.asm"

aliens:         WORD 0x1060,sprite_a_1_0,sprite_a_1_1, 0x2060,sprite_a_1_0,sprite_a_1_1, 0x3060,sprite_a_1_0,sprite_a_1_1, 0x4060,sprite_a_1_0,sprite_a_1_1, 0x5060,sprite_a_1_0,sprite_a_1_1
                WORD 0x6060,sprite_a_1_0,sprite_a_1_1, 0x7060,sprite_a_1_0,sprite_a_1_1, 0x8060,sprite_a_1_0,sprite_a_1_1, 0x9060,sprite_a_1_0,sprite_a_1_1, 0xA060,sprite_a_1_0,sprite_a_1_1

                WORD 0x1050,sprite_a_1_0,sprite_a_1_1, 0x2050,sprite_a_1_0,sprite_a_1_1, 0x3050,sprite_a_1_0,sprite_a_1_1, 0x4050,sprite_a_1_0,sprite_a_1_1, 0x5050,sprite_a_1_0,sprite_a_1_1
                WORD 0x6050,sprite_a_1_0,sprite_a_1_1, 0x7050,sprite_a_1_0,sprite_a_1_1, 0x8050,sprite_a_1_0,sprite_a_1_1, 0x9050,sprite_a_1_0,sprite_a_1_1, 0xA050,sprite_a_1_0,sprite_a_1_1

                WORD 0x1040,sprite_a_2_0,sprite_a_2_1, 0x2040,sprite_a_2_0,sprite_a_2_1, 0x3040,sprite_a_2_0,sprite_a_2_1, 0x4040,sprite_a_2_0,sprite_a_2_1, 0x5040,sprite_a_2_0,sprite_a_2_1
                WORD 0x6040,sprite_a_2_0,sprite_a_2_1, 0x7040,sprite_a_2_0,sprite_a_2_1, 0x8040,sprite_a_2_0,sprite_a_2_1, 0x9040,sprite_a_2_0,sprite_a_2_1, 0xA040,sprite_a_2_0,sprite_a_2_1

                WORD 0x1030,sprite_a_2_0,sprite_a_2_1, 0x2030,sprite_a_2_0,sprite_a_2_1, 0x3030,sprite_a_2_0,sprite_a_2_1, 0x4030,sprite_a_2_0,sprite_a_2_1, 0x5030,sprite_a_2_0,sprite_a_2_1
                WORD 0x6030,sprite_a_2_0,sprite_a_2_1, 0x7030,sprite_a_2_0,sprite_a_2_1, 0x8030,sprite_a_2_0,sprite_a_2_1, 0x9030,sprite_a_2_0,sprite_a_2_1, 0xA030,sprite_a_2_0,sprite_a_2_1

                WORD 0x1020,sprite_a_3_0,sprite_a_3_1, 0x2020,sprite_a_3_0,sprite_a_3_1, 0x3020,sprite_a_3_0,sprite_a_3_1, 0x4020,sprite_a_3_0,sprite_a_3_1, 0x5020,sprite_a_3_0,sprite_a_3_1
                WORD 0x6020,sprite_a_3_0,sprite_a_3_1, 0x7020,sprite_a_3_0,sprite_a_3_1, 0x8020,sprite_a_3_0,sprite_a_3_1, 0x9020,sprite_a_3_0,sprite_a_3_1, 0xA020,sprite_a_3_0,sprite_a_3_1

direction:      BLOCK 1

DIRECTION_LEFT: EQU 2
DIRECTION_RIGHT: EQU 1

; Put the stack immediated after the code
; This seems to be needed so the debugger knows where the stack is
STACK_SIZE: EQU 100*2    
            BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE