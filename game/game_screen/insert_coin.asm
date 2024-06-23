draw_insert_coin_section:

.PARAM_FOR_ANIMATION:   EQU 0

    PUSH AF,HL,IX

    PARAMS_IX 3                                         ; Get the stack pointer

    LD HL,.TAITO_TEXT
    PUSH HL
    LD HL,.TAITO_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD A,(IX+.PARAM_FOR_ANIMATION)
    BIT utils.TRUE_BIT,A
    JR NZ,.for_animation

    LD HL,.INSERT_COIN_TITLE

    JR .title_chosen

.for_animation:
    LD HL,.INSERT_CCOIN_TITLE

.title_chosen:
    PUSH HL
    LD HL,.INSERT_COIN_TITLE_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.ONE_OR_TWO_TEXT
    PUSH HL
    LD HL,.ONE_OR_TWO_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.ONE_COIN_TEXT
    PUSH HL
    LD HL,.ONE_COIN_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.TWO_COINS_TEXT
    PUSH HL
    LD HL,.TWO_COINS_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    POP IX,HL,AF
    
    RET

.TAITO_TEXT:                    BYTE "*TAITO CORPORATION*",0
.TAITO_X:                       EQU 7
.TAITO_Y:                       EQU 21
.TAITO_COORDS:                  EQU (.TAITO_X<<8) + .TAITO_Y

.INSERT_COIN_TITLE:             BYTE "INSERT  COIN",0
.INSERT_CCOIN_TITLE:            BYTE "INSERT CCOIN",0
.INSERT_COIN_TITLE_X:           EQU 11
.INSERT_COIN_TITLE_Y:           EQU 9
.INSERT_COIN_TITLE_COORDS:      EQU (.INSERT_COIN_TITLE_X<<8) + .INSERT_COIN_TITLE_Y

.ONE_OR_TWO_TEXT:               BYTE "<1 OR 2 PLAYERS>",0
.ONE_OR_TWO_X:                  EQU 8
.ONE_OR_TWO_Y:                  EQU 12
.ONE_OR_TWO_COORDS:             EQU (.ONE_OR_TWO_X<<8) + .ONE_OR_TWO_Y

.ONE_COIN_TEXT:                 BYTE "*1 PLAYER 1 COIN",0
.ONE_COIN_X:                    EQU 8
.ONE_COIN_Y:                    EQU 14
.ONE_COIN_COORDS:               EQU (.ONE_COIN_X<<8) + .ONE_COIN_Y

.TWO_COINS_TEXT:                BYTE "*2 PLAYERS 2 COINS",0
.TWO_COINS_X:                   EQU 8
.TWO_COINS_Y:                   EQU 16
.TWO_COINS_COORDS:              EQU (.TWO_COINS_X<<8) + .TWO_COINS_Y

play_insert_coin_animation:
    PUSH AF,HL

    ; Start X coord
    LD A,.ALIEN_X_START
    LD (.alien_x),A

    ; Y coord
    LD A,.ALIEN_Y
    LD (.alien_y),A

    ; Set starting alien variant
    LD A,0
    LD (.alien_variant),A

.alien_animation_loop:
    ; Coords
    LD HL,(.ALIEN_COORDS)
    PUSH HL

    ; Alien sprite variant
    LD A,(.alien_variant)
    CP 1
    JR NZ,.alien_variant_1

    LD HL,sprites.ALIEN_2_VARIANT_0
    JR .variant_selected

.alien_variant_1:
    LD HL,sprites.ALIEN_2_VARIANT_1
    
.variant_selected:
    ; Push the selected variant
    PUSH HL

    ; Blanking not drawing
    LD L,utils.TRUE_VALUE
    PUSH HL

    ; Blank the sprite
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL
    POP HL

    ; Update sprite location
    LD A,(.alien_x)
    ADD .ALIEN_X_INC
    LD (.alien_x),A

    ; Flip the sprite variant
    LD A,(.alien_variant)
    XOR 0x01
    LD (.alien_variant),A

     ; Coords
    LD HL,(.ALIEN_COORDS)
    PUSH HL

    ; Alien sprite variant
    LD A,(.alien_variant)
    CP 1
    JR NZ,.alien_variant_1_d

    LD HL,sprites.ALIEN_2_VARIANT_0
    JR .variant_selected_d

.alien_variant_1_d:
    LD HL,sprites.ALIEN_2_VARIANT_1

.variant_selected_d:
    ; Push the selected variant
    PUSH HL

    ; Blanking not drawing
    LD L,utils.FALSE_VALUE
    PUSH HL

    ; Blank the sprite
    CALL fast_draw.draw_sprite_16x8
    POP HL
    POP HL
    POP HL
 
    HALT
    HALT
    HALT
    HALT
    CALL fast_draw.flush_buffer_to_screen_16x8

    ; Done with alien animation?
    LD A,(.alien_x)
    CP .ALIEN_X_END
    JR NZ,.alien_animation_loop

    POP HL,AF

    RET

.ALIEN_Y:                       EQU 16
.ALIEN_COORDS:
.alien_y:                       BLOCK 1
.alien_x:                       BLOCK 1
.ALIEN_X_INC:                   EQU 2
.ALIEN_X_START:                 EQU 0
.ALIEN_X_END:                   EQU .ALIEN_X_START+(70*.ALIEN_X_INC)
.alien_variant:                 BLOCK 1