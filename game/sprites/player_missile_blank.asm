; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

PLAYER_MISSILE_BLANK_0:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_1:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_2:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_3:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_4:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_5:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_6:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 3

PLAYER_MISSILE_BLANK_7:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 3

; Dimensions x (bytes) y (pixels)
PLAYER_MISSILE_BLANK_DIMS:	EQU 0x0204
PLAYER_MISSILE_BLANK_DIM_X_BYTES:	EQU 0x02
PLAYER_MISSILE_BLANK_DIM_Y_PIXELS:	EQU 0x04

; Lookup table
PLAYER_MISSILE_BLANK:
	WORD PLAYER_MISSILE_BLANK_0, PLAYER_MISSILE_BLANK_1, PLAYER_MISSILE_BLANK_2, PLAYER_MISSILE_BLANK_3, PLAYER_MISSILE_BLANK_4, PLAYER_MISSILE_BLANK_5, PLAYER_MISSILE_BLANK_6, PLAYER_MISSILE_BLANK_7

	ENDMODULE