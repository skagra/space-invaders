; This file was automatically generated, DO NOT MODIFY

	MODULE sprites

sprite_alien_3_variant_1_0:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111110, 0b00000001, 0b01111111, 0b10000000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111100, 0b00000011, 0b00111111, 0b11000000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111000, 0b00000111, 0b00011111, 0b11100000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11110010, 0b00001101, 0b01001111, 0b10110000, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11110000, 0b00001111, 0b00001111, 0b11110000, 0b11111111, 0b00000000 ; Row 4
	BYTE 0b11111010, 0b00000101, 0b01011111, 0b10100000, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11110111, 0b00001000, 0b11101111, 0b00010000, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11111011, 0b00000100, 0b11011111, 0b00100000, 0b11111111, 0b00000000 ; Row 7

sprite_alien_3_variant_1_2:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b10011111, 0b01100000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b00001111, 0b11110000, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111110, 0b00000001, 0b00000111, 0b11111000, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111100, 0b00000011, 0b10010011, 0b01101100, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111100, 0b00000011, 0b00000011, 0b11111100, 0b11111111, 0b00000000 ; Row 4
	BYTE 0b11111110, 0b00000001, 0b10010111, 0b01101000, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11111101, 0b00000010, 0b11111011, 0b00000100, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11111110, 0b00000001, 0b11110111, 0b00001000, 0b11111111, 0b00000000 ; Row 7

sprite_alien_3_variant_1_4:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11100111, 0b00011000, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11000011, 0b00111100, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b10000001, 0b01111110, 0b11111111, 0b00000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b00100100, 0b11011011, 0b11111111, 0b00000000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b00000000, 0b11111111, 0b11111111, 0b00000000 ; Row 4
	BYTE 0b11111111, 0b00000000, 0b10100101, 0b01011010, 0b11111111, 0b00000000 ; Row 5
	BYTE 0b11111111, 0b00000000, 0b01111110, 0b10000001, 0b11111111, 0b00000000 ; Row 6
	BYTE 0b11111111, 0b00000000, 0b10111101, 0b01000010, 0b11111111, 0b00000000 ; Row 7

sprite_alien_3_variant_1_6:
	     ;  Mask       Sprite       Mask       Sprite       Mask       Sprite     
	BYTE 0b11111111, 0b00000000, 0b11111001, 0b00000110, 0b11111111, 0b00000000 ; Row 0
	BYTE 0b11111111, 0b00000000, 0b11110000, 0b00001111, 0b11111111, 0b00000000 ; Row 1
	BYTE 0b11111111, 0b00000000, 0b11100000, 0b00011111, 0b01111111, 0b10000000 ; Row 2
	BYTE 0b11111111, 0b00000000, 0b11001001, 0b00110110, 0b00111111, 0b11000000 ; Row 3
	BYTE 0b11111111, 0b00000000, 0b11000000, 0b00111111, 0b00111111, 0b11000000 ; Row 4
	BYTE 0b11111111, 0b00000000, 0b11101001, 0b00010110, 0b01111111, 0b10000000 ; Row 5
	BYTE 0b11111111, 0b00000000, 0b11011111, 0b00100000, 0b10111111, 0b01000000 ; Row 6
	BYTE 0b11111111, 0b00000000, 0b11101111, 0b00010000, 0b01111111, 0b10000000 ; Row 7

; Dimensions x (bytes) y (pixels)
sprite_alien_3_variant_1_dims:	EQU 0x0308
sprite_alien_3_variant_1_dim_x_bytes:	EQU 0x03
sprite_alien_3_variant_1_dim_y_pixels:	EQU 0x08

; Lookup table
sprite_alien_3_variant_1:
	WORD sprite_alien_3_variant_1_0, sprite_alien_3_variant_1_0, sprite_alien_3_variant_1_2, sprite_alien_3_variant_1_2, sprite_alien_3_variant_1_4, sprite_alien_3_variant_1_4, sprite_alien_3_variant_1_6, sprite_alien_3_variant_1_6

	ENDMODULE
