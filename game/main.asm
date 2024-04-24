; SLD Features
    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    INCLUDE "memory_map.asm"

; Reserve space for screen memory and skip over for code start    
    ORG 0x0
    BLOCK mmap.FREE_MEMORY_START

    ORG 0x8000 ; Skip ULA contended memory? https://worldofspectrum.org/faq/reference/48kreference.htm

    INCLUDE "utils.asm"
    INCLUDE "draw.asm"
    
    MODULE main

main:
    ; Set up stack

    DI                          
    LD SP,STACK_TOP
    EI

    call draw.wipe_screen

    ; Fill the screen
    LD H,draw.CA_BG_BLACK | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen_attributes
    POP HL

; FSAR_PARAM_TOP_LEFT:          EQU 16
; FSAR_PARAM_DIM:               EQU 14
; FSAR_PARAM_ATTRIBUTE:         EQU 12

    LD HL,0x0505        ; top left
    PUSH HL
    LD HL,0x050A        ; dimensions
    PUSH HL
    LD HL,draw.CA_BG_GREEN | draw.CA_FG_YELLOW
    PUSH HL
    CALL draw.fill_screen_attributes_rect
    POP HL
    POP HL
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
    
    ; Blank old sprite
    LD DE,(HL)             ; Coords of current alien
    PUSH DE     
    ; HACK
    LD DE, 0x0308
    PUSH DE
    ; HACK
    LD DE,sprite_blank     ; Background square
    PUSH DE
    LD DE,mask_2x16
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    ; Move sprite to new position
    LD DE,(HL)              ; Coords - at start of alien definition
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

    ; HACK
    LD DE, 0x0308
    PUSH DE
    ; HACK

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
    LD DE,mask_2x16
    PUSH DE
    CALL draw.draw_sprite   ; Draw the alien sprite
    POP DE                  ; Remove parameters from stack
    POP DE
    POP DE
    POP DE
    DEC B                   ; One more alien has been done, dec loop counter
    JR NZ,draw_pack_loop    ; Done drawing sheet of aliens?

    DEC C                   ; One more cycle of animating pack done
    JP NZ,animation_loop    ; Done animating?

forever: JP forever

; Data
    INCLUDE "processed_sprites/mask_2x16.asm"
    INCLUDE "processed_sprites/sprite_blank.asm"
    INCLUDE "processed_sprites/sprite_alien_1_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_1_variant_1.asm"
    INCLUDE "processed_sprites/sprite_alien_2_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_2_variant_1.asm"
    INCLUDE "processed_sprites/sprite_alien_3_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_3_variant_1.asm"

aliens:         
    WORD 0x1060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x2060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x3060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x4060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x5060,sprite_alien_1_variant_0,sprite_alien_1_variant_1
    WORD 0x6060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x7060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x8060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x9060,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0xA060,sprite_alien_1_variant_0,sprite_alien_1_variant_1

    WORD 0x1050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x2050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x3050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x4050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x5050,sprite_alien_1_variant_0,sprite_alien_1_variant_1
    WORD 0x6050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x7050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x8050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0x9050,sprite_alien_1_variant_0,sprite_alien_1_variant_1, 0xA050,sprite_alien_1_variant_0,sprite_alien_1_variant_1

    WORD 0x1040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x2040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x3040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x4040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x5040,sprite_alien_2_variant_0,sprite_alien_2_variant_1
    WORD 0x6040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x7040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x8040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x9040,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0xA040,sprite_alien_2_variant_0,sprite_alien_2_variant_1

    WORD 0x1030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x2030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x3030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x4030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x5030,sprite_alien_2_variant_0,sprite_alien_2_variant_1
    WORD 0x6030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x7030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x8030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0x9030,sprite_alien_2_variant_0,sprite_alien_2_variant_1, 0xA030,sprite_alien_2_variant_0,sprite_alien_2_variant_1

    WORD 0x1020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x2020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x3020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x4020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x5020,sprite_alien_3_variant_0,sprite_alien_3_variant_1
    WORD 0x6020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x7020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x8020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0x9020,sprite_alien_3_variant_0,sprite_alien_3_variant_1, 0xA020,sprite_alien_3_variant_0,sprite_alien_3_variant_1

direction:          BLOCK 1
DIRECTION_LEFT:     EQU 2
DIRECTION_RIGHT:    EQU 1

; Put the stack immediated after the code
; This seems to be needed so the debugger knows where the stack is
STACK_SIZE: EQU 100*2    
            BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

; Save snapshot for spectrum emulator
    SAVESNA "space-invaders.sna",main
   
    ENDMODULE


    ; LD HL,0x2130            ; X,Y coords
    ; PUSH HL
    ; LD HL,(sprite_alien_1_variant_0_dims)     ; Dimensions
    ; PUSH HL
    ; LD HL,sprite_alien_1_variant_0            ; Sprite data
    ; PUSH HL
    ; LD HL,mask_2x16         ; Mask
    ; PUSH HL
    ; CALL draw.draw_sprite
    ; POP HL
    ; POP HL
    ; POP HL
    ; POP HL