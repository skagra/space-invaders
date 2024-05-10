; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

sprite_player_bullet_blank_0:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110111, 0b00000000, 0b11111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_1:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111011, 0b00000000, 0b11111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_2:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111101, 0b00000000, 0b11111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_3:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111110, 0b00000000, 0b11111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_4:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b01111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_5:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b10111111, 0b00000000 ; Row 3

sprite_player_bullet_blank_6:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00000000 ; Row 3

sprite_player_bullet_blank_7:
	     ;  Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00000000 ; Row 3

; Dimensions x (bytes) y (pixels)
sprite_player_bullet_blank_dims:	EQU 0x0204
sprite_player_bullet_blank_dim_x_bytes:	EQU 0x02
sprite_player_bullet_blank_dim_y_pixels:	EQU 0x04

; Lookup table
sprite_player_bullet_blank:
	WORD sprite_player_bullet_blank_0, sprite_player_bullet_blank_1, sprite_player_bullet_blank_2, sprite_player_bullet_blank_3, sprite_player_bullet_blank_4, sprite_player_bullet_blank_5, sprite_player_bullet_blank_6, sprite_player_bullet_blank_7

	ENDMODULE
