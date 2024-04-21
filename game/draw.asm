    MODULE draw

SCREEN_WIDTH_PIXELS:    EQU 256
SCREEN_HEIGHT_PIXELS:   EQU 192
SCREEN_WIDTH_CHARS:     EQU 32
SCREEN_HEIGHT_CHARS:    EQU 24

; Flash attribute
CA_FLASH:       EQU 0b10000000

; Bright attribute
CA_BRIGHT:      EQU 0b01000000

; Colour definitions
CA_COL_BLACK:   EQU 0b000
CA_COL_BLUE:    EQU 0b001
CA_COL_RED:     EQU 0b010
CA_COL_MAGENTA: EQU 0b011
CA_COL_GREEN:   EQU 0b100
CA_COL_CYAN:    EQU 0b101
CA_COL_YELLOW:  EQU 0b110
CA_COL_WHITE:   EQU 0b111

; Foreground colours
CA_FG_BLACK:    EQU CA_COL_BLACK 
CA_FG_BLUE:     EQU CA_COL_BLUE
CA_FG_RED:      EQU CA_COL_RED
CA_FG_MAGENTA:  EQU CA_COL_MAGENTA
CA_FG_GREEN:    EQU CA_COL_GREEN
CA_FG_CYAN:     EQU CA_COL_CYAN
CA_FG_YELLOW:   EQU CA_COL_YELLOW
CA_FG_WHITE:    EQU CA_COL_WHITE

; Background colours
CA_BG_BLACK:    EQU CA_COL_BLACK << 3
CA_BG_BLUE:     EQU CA_COL_BLUE << 3
CA_BG_RED:      EQU CA_COL_RED << 3
CA_BG_MAGENTA:  EQU CA_COL_MAGENTA << 3
CA_BG_GREEN:    EQU CA_COL_GREEN << 3
CA_BG_CYAN:     EQU CA_COL_CYAN << 3
CA_BG_YELLOW:   EQU CA_COL_YELLOW << 3
CA_BG_WHITE:    EQU CA_COL_WHITE << 3

; usage PUSH color
fill_screen:
    PUSH HL,IX    

    ; Erase contents of screen
    LD HL,0x0000
    PUSH HL
    LD HL,mmap.SCREEN_START
    PUSH HL
    LD HL, mmap.SCREEN_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL,HL,HL

    ; Fill screen with the given colour
    LD  IX,0
    ADD IX,SP
    LD HL, (ix+7)    ; get the bg colour from the stack
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_START
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL,HL,HL 

    POP IX,HL
    RET

; 15 14	13 12 11 10 9  8  7  6  5  4  3  2  1  0
; 0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X7 X6 X5 X4 X3
; 
; X2 X1 X0 gives bit offset with screen byte

; Push XY onto stack
; Returns address in HL

coords_to_mem:
    PUSH AF,BC,IX
   
    LD  IX,0
    ADD IX,SP
    LD BC, (IX+8)

    LD A,C          ; Calculate Y2,Y1,Y0
    AND %00000111   ; Mask out unwanted bits
    OR %01000000    ; Set base address of screen
    LD H,A          ; Store in H
    LD A,C          ; Calculate Y7,Y6
    RRA             ; Shift to position
    RRA
    RRA
    AND %00011000   ; Mask out unwanted bits
    OR H            ; OR with Y2,Y1,Y0
    LD H,A          ; Store in H
    LD A,C          ; Calculate Y5,Y4,Y3
    RLA             ; Shift to position
    RLA
    AND %11100000   ; Mask out unwanted bits
    LD L,A          ; Store in L
    LD A,B          ; Calculate X4,X3,X2,X1,X0
    RRA             ; Shift into position
    RRA
    RRA
    AND %00011111   ; Mask out unwanted bits
    OR L            ; OR with Y5,Y4,Y3
    LD L,A          ; Store in L

    POP IX,BC,AF
    RET

DS_PARAM_COORDS:            EQU 14
DS_PARAM_SPRITE_DATA:       EQU 12

draw_sprite:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0
    ADD IX,SP                           ; Point IX to the stack

    LD HL, (IX+DS_PARAM_SPRITE_DATA)    ; Start of sprite data
    LD BC, (HL)
    LD (dims), BC                       ; Grab dimension data (X in characters, Y in pixel lines)

    INC HL                              ; Skip to bitmap data
    INC HL

    LD DE, HL                           ; DE will point at sprite data throughout

    LD HL, (IX+DS_PARAM_COORDS)         ; Grab the pixel coords

    LD A,(y_dim)                        ; Y dim loop counter - pixel lines
    LD C,A
yloop:                      
    PUSH HL                 
    CALL coords_to_mem                  ; Memory location of screen byte into HL
    LD A,(x_dim)                        ; X dim loop counter - character cells
    LD B,A
xloop:
    LD A, (DE)                          ; Get sprite data for current byte
    LD (HL), A                          ; Write sprite data to the screen

    INC DE                              ; Move to next byte of sprite data
    INC HL                              ; Move to next X cell

    DEC B                               ; Decrease the X loop counter
    JR NZ,xloop                         ; Next X
    
    POP HL                              ; Coords
    INC HL                              ; Next Y row
    
    DEC C                               ; Y loop counter
    JR NZ,yloop

    POP IX,HL,DE,BC,AF   
    RET

dims:
x_dim:   BLOCK 1
y_dim:   BLOCK 1

    MACRO X_OFFSET_IN_A reg
        LD A,reg
        AND 0b00000111
    ENDM

    ENDMODULE

   