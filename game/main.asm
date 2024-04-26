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
    
    MODULE main

;------------------------------------------------------------------------------
;
; Draw the initial screen.
; 
; Usage:
;   CALL init_screen
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

BOTTOM_GEL_TOP_LEFT_Y:  EQU draw.SCREEN_HEIGHT_CHARS-6
BOTTOM_GEL_HEIGHT:      EQU 5
BASES_GEL_TOP_LEFT_X:   EQU 3
BASES_GEL_TOP_LEFT_Y:   EQU draw.SCREEN_HEIGHT_CHARS-1
BASES_GEL_WIDTH:        EQU 10
BASES_GEL_HEIGHT:       EQU 1
SPACESHIP_GEL_LEFT_Y:   EQU 2
SPACESHIP_GEL_HEIGHT:   EQU 1
init_screen:
    PUSH HL

    ; Clear the screen
    call draw.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw.CA_BG_BLACK | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen_attributes
    POP HL

    ; Green gel to cover active player base and defences
    LD H,BOTTOM_GEL_TOP_LEFT_Y                                  ; Top left X
    LD L,BOTTOM_GEL_HEIGHT                                      ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                      ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Gren gel covering bases showing remaining lives
    LD H,BASES_GEL_TOP_LEFT_X                                   ; Top left X
    LD L,BASES_GEL_TOP_LEFT_Y                                   ; Top left Y
    PUSH HL
    LD H,BASES_GEL_WIDTH                                        ; Width
    LD L,BASES_GEL_HEIGHT                                       ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                      ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,SPACESHIP_GEL_LEFT_Y                                   ; Top left X
    LD L,SPACESHIP_GEL_HEIGHT                                   ; Height
    PUSH HL
    LD HL,draw.CA_FG_RED                                        ; Red fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Draw static screen labels. 
    LD HL,score_line_0_text
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,score_line_1_text
    PUSH HL
    LD HL,0x0001
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,lives_and_creds_text
    PUSH HL
    LD HL,draw.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    POP HL

    CALL draw_score_1
    CALL draw_score_2
    CALL draw_high_score
    CALL draw_credit
    CALL draw_bases_count
    CALL draw_reserve_bases

    RET

; TODO
draw_score_1:
    RET

; TODO
draw_score_2:
    RET

; TODO
draw_high_score:
    RET

; TODO
draw_credit:
    RET
    
; TODO
draw_bases_count:
    RET

; TODO
draw_reserve_bases:
    PUSH DE

    LD D,RESERVE_BASE_1_X
    LD E,RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    LD D,RESERVE_BASE_2_X
    LD E,RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    POP DE

    RET

RESERVE_BASE_Y:     EQU draw.SCREEN_HEIGHT_PIXELS-8-1
RESERVE_BASE_1_X:   EQU 3*8
RESERVE_BASE_2_X:   EQU RESERVE_BASE_1_X+16

DRB_PARAM_COORDS:  EQU 6

draw_reserve_base:
    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+DRB_PARAM_COORDS)             
    PUSH DE     
    ; HACK
    LD DE, 0x0308
    PUSH DE
    LD DE,sprite_base     
    PUSH DE
    LD DE,mask_2x16
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

score_line_0_text:    BYTE " SCORE<1>   HI-SCORE   SCORE<2> ",0
score_line_1_text:    BYTE "   0000      0000        0000   ",0
lives_and_creds_text: BYTE " 3                    CREDIT 00 ",0

;------------------------------------------------------------------------------
;
; Draw the player base, read the keyboard and move the player base based on 
; key presses.
; 
; Usage:
;   CALL process_player
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

process_player:
    PUSH AF,DE

    ; Draw the player base sprite
    LD A, (player_x)                        ; Player base coords
    LD D,A
    LD E, PLAYER_Y
    PUSH DE

    ; HACK          
    LD DE, 0x0308                           ; Player base dimensions
    PUSH DE

    LD DE,sprite_base                       ; Sprite    
    PUSH DE

    LD DE,mask_2x16                         ; Sprite mask
    PUSH DE

    CALL draw.draw_sprite                   ; Draw the player base sprite
    POP DE
    POP DE
    POP DE
    POP DE

    ; Read the keyboard
    PUSH DE                                 ; Allocate space on stack for return value
    CALL keyboard.get_movement_keys
    POP DE                                  ; Keys pressed

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E        ; Left pressed?
    JR Z,.left_not_pressed                  ; No

    LD A,(player_x)                         ; Get current player base X coord
    DEC A                                   ; Decrease it to move left
    CP MIN_PLAYER_X                         ; Have we hit the left most point?
    JR Z,.done                              ; Yes so don't update
    LD (player_x),A                         ; Update the location of the player base
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E       ; Right pressed?
    JR Z,.done                              ; No
    LD A,(player_x)                         ; Get current player base X coord
    INC A                                   ; Increase it to move right
    CP MAX_PLAYER_X                         ; Have we hit the right most point?
    JR NC,.done                             ; Yes so don't update
    LD (player_x),A                         ; Update the location of the player base

.done:
    POP DE,AF

    RET

player_x:       BYTE draw.SCREEN_WIDTH_PIXELS/2-8
PLAYER_Y:       EQU draw.SCREEN_HEIGHT_PIXELS-8*2-1
MIN_PLAYER_X:   EQU 0
MAX_PLAYER_X:   EQU draw.SCREEN_WIDTH_PIXELS-16


DA_PARAM_OLD_COORDS:    EQU 12
DA_PARAM_NEW_COORDS:    EQU 10
DA_PARAM_SPRITE_DATA:   EQU 8

draw_alien:
    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP 

    ; Blank old sprite position
    LD DE,(IX+DA_PARAM_OLD_COORDS)          ; Coords
    PUSH DE     
    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE
    LD DE,sprite_blank                      ; Background square
    PUSH DE
    LD DE,mask_2x16                         ; Mask
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    ; Draw sprite in new position
    LD DE,(IX+DA_PARAM_NEW_COORDS)          ; Coords
    PUSH DE     
    ; HACK
    LD DE, 0x0308                           ; Dimensions
    PUSH DE
    LD DE,(IX+DA_PARAM_SPRITE_DATA)         ; Background square
    PUSH DE
    LD DE,mask_2x16                         ; Mask
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

main:
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Draw the initial screen
    CALL init_screen

    ; Count of animation cycles
    LD C, 60

    ; Alien pack direction
    LD A,DIRECTION_RIGHT
    LD (direction),A

animation_loop:
    LD B,50                                 ; Alien pack size
    LD HL,aliens                            ; Pointer to aliens definitions

draw_pack_loop:
    ; Wait for screen blank
    HALT
    
    ; Blank old sprite
    LD DE,(HL)                              ; Coords of current alien
    PUSH DE     
    ; HACK
    LD DE, 0x0308
    PUSH DE
    LD DE,sprite_blank                      ; Background square
    PUSH DE
    LD DE,mask_2x16
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    ; Move sprite to new position
    LD DE,(HL)              ; Coords are at start of alien definition
    LD A,C
    AND 0b00000011          ; Is it time to move down instead of sideways?
    CP 0b00000010
    JR Z, down

    ; Sideways movement
    LD A,(direction)        ; Are we going left or right?
    CP DIRECTION_RIGHT
    JR Z,going_right
    DEC D
    DEC D
    JR moved
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

    CALL process_player

    DEC B                   ; One more alien has been done, dec loop counter
    JP NZ,draw_pack_loop    ; Done drawing sheet of aliens?

    LD A,C                  ; Is it time to chnage direction?
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

    DEC C                   ; One more cycle of animating pack done
    JP NZ,animation_loop    ; Done animating?

forever: JP forever

; Sprite data
    INCLUDE "processed_sprites/mask_2x16.asm"
    INCLUDE "processed_sprites/sprite_blank.asm"
    INCLUDE "processed_sprites/sprite_base.asm"
    INCLUDE "processed_sprites/sprite_alien_1_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_1_variant_1.asm"
    INCLUDE "processed_sprites/sprite_alien_2_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_2_variant_1.asm"
    INCLUDE "processed_sprites/sprite_alien_3_variant_0.asm"
    INCLUDE "processed_sprites/sprite_alien_3_variant_1.asm"

; Alien pack
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
