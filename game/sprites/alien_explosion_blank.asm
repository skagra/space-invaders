; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

ALIEN_EXPLOSION_BLANK_0:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111011, 0b00000000, 0b10111111, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11011101, 0b00000000, 0b01110111, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11101111, 0b00000000, 0b11101111, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110111, 0b00000000, 0b11011111, 0b00000000, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b10011111, 0b00000000, 0b11110011, 0b00000000, 0b11111111, 0b00000000 ; Row 4
	BYTE 0b11110111, 0b00000000, 0b11011111, 0b00000000, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11101101, 0b00000000, 0b01101111, 0b00000000, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11011011, 0b00000000, 0b10110111, 0b00000000, 0b11111111, 0b00000000 ; Row 7

ALIEN_EXPLOSION_BLANK_2:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000000, 0b11101111, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11110111, 0b00000000, 0b01011101, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111011, 0b00000000, 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111101, 0b00000000, 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11100111, 0b00000000, 0b11111100, 0b00000000, 0b11111111, 0b00000000 ; Row 4
	BYTE 0b11111101, 0b00000000, 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11111011, 0b00000000, 0b01011011, 0b00000000, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11110110, 0b00000000, 0b11101101, 0b00000000, 0b11111111, 0b00000000 ; Row 7

ALIEN_EXPLOSION_BLANK_4:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10111011, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111101, 0b00000000, 0b11010111, 0b00000000, 0b01111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000000, 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b01111101, 0b00000000, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111001, 0b00000000, 0b11111111, 0b00000000, 0b00111111, 0b00000000 ; Row 4
	BYTE 0b11111111, 0b00000000, 0b01111101, 0b00000000, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11111110, 0b00000000, 0b11010110, 0b00000000, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11111101, 0b00000000, 0b10111011, 0b00000000, 0b01111111, 0b00000000 ; Row 7

ALIEN_EXPLOSION_BLANK_6:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11101110, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b01110101, 0b00000000, 0b11011111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000, 0b10111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000, 0b01111111, 0b00000000 ; Row 3
	BYTE 0b11111110, 0b00000000, 0b01111111, 0b00000000, 0b11001111, 0b00000000 ; Row 4
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000, 0b01111111, 0b00000000 ; Row 5
	BYTE 0b11111111, 0b00000000, 0b10110101, 0b00000000, 0b10111111, 0b00000000 ; Row 6
	BYTE 0b11111111, 0b00000000, 0b01101110, 0b00000000, 0b11011111, 0b00000000 ; Row 7

; Dimensions x (bytes) y (pixels)
ALIEN_EXPLOSION_BLANK_DIMS:	EQU 0x0308
ALIEN_EXPLOSION_BLANK_DIM_X_BYTES:	EQU 0x03
ALIEN_EXPLOSION_BLANK_DIM_Y_PIXELS:	EQU 0x08

; Lookup table
ALIEN_EXPLOSION_BLANK:
	WORD ALIEN_EXPLOSION_BLANK_0, ALIEN_EXPLOSION_BLANK_0, ALIEN_EXPLOSION_BLANK_2, ALIEN_EXPLOSION_BLANK_2, ALIEN_EXPLOSION_BLANK_4, ALIEN_EXPLOSION_BLANK_4, ALIEN_EXPLOSION_BLANK_6, ALIEN_EXPLOSION_BLANK_6

	ENDMODULE