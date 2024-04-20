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

; https://www.overtakenbyevents.com/lets-talk-about-the-zx-specrum-screen-layout-part-three/
; 15 14	13 12 11 10 9  8  7  6  5  4  3  2  1  0
; 0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X4 X3 X2 X1 X0

coords_to_mem:
    LD H, 0 		
    LD L, B 		    ; HL = Y
    ADD HL, HL 	 	    ; HL = Y * 2
    LD DE, screen_map   ; DE = SCREEN_MAP
    ADD HL, DE 	 	    ; HL = SCREEN_MAP + (ROW * 2)
    LD A, (HL) 	 	    ; IMPLEMENTS LD HL, (HL)
    INC HL 	 	
    LD H, (HL)
    LD L, A 	 	    ; HL = ADDRESS OF FIRST PIXEL FROM SCREEN_MAP
    LD D, 0 	 	
    LD E, C 	 	    ; DE = X
    ADD HL, DE 	 	    ; ADD THE CHAR X OFFSET
    RET 		        ; RETURN SCREEN_MAP[Y*2] + X 

screen_map: WORD 0x4000, 0x4100, 0x4200, 0x4300, 0x4400, 0x4500, 0x4600, 0x4700, 0x4020, 0x4120, 0x4220, 0x4320 

    ENDMODULE
