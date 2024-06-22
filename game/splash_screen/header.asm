draw_header:
    PUSH BC,DE,HL,IX

    LD H,0
    LD L,7
    PUSH HL
    LD L,colours.CA_FG_RED | colours.CA_BG_BLACK
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    LD H,8
    LD L,5
    PUSH HL
    LD L,colours.CA_FG_GREEN | colours.CA_BG_BLACK
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    LD B,.HEADER_COUNT
    LD HL,.HEADER

.loop:
    LD E,(HL) : INC HL : LD D,(HL) : DEC HL                 ; Current line
    PUSH HL : POP IX

    LD E,(IX+.HEADER_TEXT_OFFSET)
    LD D,(IX+.HEADER_TEXT_OFFSET+1)
    PUSH DE

    LD E,(IX+.HEADER_COORDS_OFFSET)
    LD D,(IX+.HEADER_COORDS_OFFSET+1)
    PUSH DE

    CALL draw_header_line

    POP DE
    POP DE

    INC HL
    INC HL
    INC HL
    INC HL

    DJNZ .loop

    POP IX,HL,DE,BC

    RET

.H0:    BYTE " Z -ZZ - Z - Z -ZZZ",0
.H1:    BYTE "Y Y-Y Y-Y Y-Y Y-Y  ",0
.H2:    BYTE "X  -X X-X X-X  -X  ",0
.H3:    BYTE " Z -ZZ -ZZZ-Z  -ZZ ",0
.H4:    BYTE "  Y-Y  -Y Y-Y  -Y  ",0
.H5:    BYTE "X X-X  -X X-X X-X  ",0
.H6:    BYTE " Z -Z  -Z Z- Z -ZZZ",0

.H7:    BYTE "OOO_OOO_O_O__O__OO__OOO_OO___OO",0
.H8:    BYTE "_O__O_O_O_O_O_O_O_O_O___O_O_O__",0
.H9:    BYTE "_O__O_O_O_O_OOO_O_O_OO__OO__OOO",0
.H10:   BYTE "_O__O_O_O_O_O_O_O_O_O___O_O___O",0
.H11:   BYTE "OOO_O_O__O__O_O_OO__OOO_O_O_OO_",0

.HEADER: 
    WORD 0x0200,.H0
    WORD 0x0201,.H1
    WORD 0x0202,.H2
    WORD 0x0203,.H3
    WORD 0x0204,.H4
    WORD 0x0205,.H5
    WORD 0x0206,.H6

    WORD 0x0108,.H7
    WORD 0x0109,.H8
    WORD 0x010A,.H9
    WORD 0x010B,.H10
    WORD 0x010C,.H11

.HEADER_COUNT:          EQU ($-.HEADER)/4

.HEADER_COORDS_OFFSET:  EQU 0
.HEADER_TEXT_OFFSET:    EQU 2

draw_header_line:

.PARAM_TEXT: EQU 2
.PARAM_COORDS: EQU 0

    PUSH AF,BC,DE,HL,IX

    PARAMS_IX 5                         ; Get the stack pointer

    LD E,(IX+.PARAM_COORDS)             ; Character coords
    LD D,(IX+.PARAM_COORDS+1)

    SLA D                               ; x 8 to give pixel coord X
    SLA D
    SLA D
    SLA E                               ; x 8 to give pixel coord Y
    SLA E
    SLA E

    LD L,(IX+.PARAM_TEXT)
    LD H,(IX+.PARAM_TEXT+1)
    
.loop:
    LD A,(HL)

    CP 0x00
    JP Z,.done
    
    CP ' '
    JR Z,.alien_space

    CP '-'
    JR Z,.alien_character_gap

    CP 'X'
    JR Z,.alien_0

    CP 'Y'
    JR Z,.alien_1

    CP 'Z'
    JR Z,.alien_2

    CP 'O'
    JR Z,.square

    CP "_"
    JR Z,.square_gap

    JR .next

.alien_0:
    PUSH DE                                ; Coords
    LD BC,sprites.ALIEN_0_VARIANT_0_DIMS   ; Dims
    PUSH BC
    LD BC,sprites.ALIEN_0_VARIANT_0        ; Sprite
    PUSH BC
    CALL draw.draw_sprite_and_flush_buffer
    POP BC
    POP BC
    POP BC

    LD A,.ALIEN_X_SIZE                     ; Next X cell
    ADD D
    LD D,A

    JR .next

.alien_1:
    PUSH DE                                ; Coords
    LD BC,sprites.ALIEN_1_VARIANT_0_DIMS   ; Dims
    PUSH BC
    LD BC,sprites.ALIEN_1_VARIANT_0        ; Sprite
    PUSH BC
    CALL draw.draw_sprite_and_flush_buffer
    POP BC
    POP BC
    POP BC

    LD A,.ALIEN_X_SIZE                     ; Next X cell
    ADD D
    LD D,A

    JR .next

.alien_2:
    PUSH DE                                ; Coords
    LD BC,sprites.ALIEN_2_VARIANT_0_DIMS   ; Dims
    PUSH BC
    LD BC,sprites.ALIEN_2_VARIANT_0        ; Sprite
    PUSH BC
    CALL draw.draw_sprite_and_flush_buffer
    POP BC
    POP BC
    POP BC

    LD A,.ALIEN_X_SIZE                     ; Next X cell
    ADD D
    LD D,A

    JR .next

.square:
     PUSH DE                                ; Coords
    LD BC,sprites.SQUARE_DIMS               ; Dims
    PUSH BC
    LD BC,sprites.SQUARE                    ; Sprite
    PUSH BC
    CALL draw.draw_sprite_and_flush_buffer
    POP BC
    POP BC
    POP BC

    LD A,.SQUARE_X_SIZE                     ; Next X cell
    ADD D
    LD D,A

    JR .next

.alien_space:
    LD A,.ALIEN_X_SIZE                       ; Next X cell
    ADD D
    LD D,A

    JR .next

.alien_character_gap:
    LD A,.ALIEN_CHARACTER_GAP_SIZE          ; Next X cell
    ADD D
    LD D,A

    JR .next

.square_gap:
    LD A,.SQUARE_X_SIZE                     ; Next X cell
    ADD D
    LD D,A

    JR .next

.next:
    INC HL                                  ; Next character
    
    JP .loop

.done
    POP IX,HL,DE,BC,AF
    
    RET

.ALIEN_X_SIZE:                  EQU 0x0C
.SQUARE_X_SIZE:                 EQU 0x08
.ALIEN_CHARACTER_GAP_SIZE:      EQU 0x0A