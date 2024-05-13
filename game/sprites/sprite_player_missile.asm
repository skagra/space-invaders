; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

sprite_player_missile_0:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 3

sprite_player_missile_1:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 3

sprite_player_missile_2:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 3

sprite_player_missile_3:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 3

sprite_player_missile_4:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 3

sprite_player_missile_5:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 3

sprite_player_missile_6:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 3

sprite_player_missile_7:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 3

; Dimensions x (bytes) y (pixels)
sprite_player_missile_dims:	EQU 0x0204
sprite_player_missile_dim_x_bytes:	EQU 0x02
sprite_player_missile_dim_y_pixels:	EQU 0x04

; Lookup table
sprite_player_missile:
	WORD sprite_player_missile_0, sprite_player_missile_1, sprite_player_missile_2, sprite_player_missile_3, sprite_player_missile_4, sprite_player_missile_5, sprite_player_missile_6, sprite_player_missile_7

	ENDMODULE
