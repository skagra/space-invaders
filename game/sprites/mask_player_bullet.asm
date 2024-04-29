; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

mask_player_bullet_0:
	BYTE 0b00001000, 0b00000000
	BYTE 0b00001000, 0b00000000
	BYTE 0b00001000, 0b00000000
	BYTE 0b00001000, 0b00000000

mask_player_bullet_1:
	BYTE 0b00000100, 0b00000000
	BYTE 0b00000100, 0b00000000
	BYTE 0b00000100, 0b00000000
	BYTE 0b00000100, 0b00000000

mask_player_bullet_2:
	BYTE 0b00000010, 0b00000000
	BYTE 0b00000010, 0b00000000
	BYTE 0b00000010, 0b00000000
	BYTE 0b00000010, 0b00000000

mask_player_bullet_3:
	BYTE 0b00000001, 0b00000000
	BYTE 0b00000001, 0b00000000
	BYTE 0b00000001, 0b00000000
	BYTE 0b00000001, 0b00000000

mask_player_bullet_4:
	BYTE 0b00000000, 0b10000000
	BYTE 0b00000000, 0b10000000
	BYTE 0b00000000, 0b10000000
	BYTE 0b00000000, 0b10000000

mask_player_bullet_5:
	BYTE 0b00000000, 0b01000000
	BYTE 0b00000000, 0b01000000
	BYTE 0b00000000, 0b01000000
	BYTE 0b00000000, 0b01000000

mask_player_bullet_6:
	BYTE 0b00000000, 0b00100000
	BYTE 0b00000000, 0b00100000
	BYTE 0b00000000, 0b00100000
	BYTE 0b00000000, 0b00100000

mask_player_bullet_7:
	BYTE 0b00000000, 0b00010000
	BYTE 0b00000000, 0b00010000
	BYTE 0b00000000, 0b00010000
	BYTE 0b00000000, 0b00010000

; Dimensions x (bytes) y (pixels)
mask_player_bullet_dims:
mask_player_bullet_dim_y_pixels:	BYTE 0x04
mask_player_bullet_dim_x_bytes:	BYTE 0x02

; Lookup table
mask_player_bullet:
	WORD mask_player_bullet_0, mask_player_bullet_1, mask_player_bullet_2, mask_player_bullet_3, mask_player_bullet_4, mask_player_bullet_5, mask_player_bullet_6, mask_player_bullet_7

	ENDMODULE
