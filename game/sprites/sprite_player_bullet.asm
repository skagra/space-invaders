; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

sprite_player_bullet_0:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 4

sprite_player_bullet_1:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 4

sprite_player_bullet_2:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111101, 0b00000010, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 4

sprite_player_bullet_3:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111110, 0b00000001, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 4

sprite_player_bullet_4:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b10000000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 4

sprite_player_bullet_5:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b01000000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 4

sprite_player_bullet_6:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 4

sprite_player_bullet_7:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 4

; Dimensions x (bytes) y (pixels)
sprite_player_bullet_dims:	EQU 0x0205
sprite_player_bullet_dim_x_bytes:	EQU 0x02
sprite_player_bullet_dim_y_pixels:	EQU 0x05

; Lookup table
sprite_player_bullet:
	WORD sprite_player_bullet_0, sprite_player_bullet_1, sprite_player_bullet_2, sprite_player_bullet_3, sprite_player_bullet_4, sprite_player_bullet_5, sprite_player_bullet_6, sprite_player_bullet_7

	ENDMODULE
