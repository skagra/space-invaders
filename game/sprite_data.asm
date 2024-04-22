mask_2_16:
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111
                BYTE 0b11111111, 0b11111111

sprite_blank:   WORD 0x0208
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000
                BYTE 0b00000000, 0b00000000   

; First alien 
sprite_a_1_0:   WORD 0x0208
                BYTE 0b00000011, 0b11000000
                BYTE 0b00011111, 0b11111000
                BYTE 0b00111111, 0b11111100
                BYTE 0b00111001, 0b10011100
                BYTE 0b00111111, 0b11111100
                BYTE 0b00000110, 0b01100000
                BYTE 0b00001101, 0b10110000
                BYTE 0b00110000, 0b00001100

sprite_a_1_1:   WORD 0x0208
                BYTE 0b00000011, 0b11000000
                BYTE 0b00011111, 0b11111000
                BYTE 0b00111111, 0b11111100
                BYTE 0b00111001, 0b10011100
                BYTE 0b00111111, 0b11111100
                BYTE 0b00001110, 0b01110000
                BYTE 0b00011001, 0b10011000
                BYTE 0b00001100, 0b00110000

; Second alien
sprite_a_2_0:   WORD 0x0208
                BYTE 0b00000100, 0b00010000
                BYTE 0b00010010, 0b00100100
                BYTE 0b00010111, 0b11110100
                BYTE 0b00011101, 0b11011100
                BYTE 0b00011111, 0b11111100
                BYTE 0b00001111, 0b11111000
                BYTE 0b00000100, 0b00010000
                BYTE 0b00001000, 0b00001000

sprite_a_2_1:   WORD 0x0208
                BYTE 0b00000100, 0b00010000
                BYTE 0b00000010, 0b00100000
                BYTE 0b00000111, 0b11110000
                BYTE 0b00001101, 0b11011000
                BYTE 0b00011111, 0b11111100
                BYTE 0b00010111, 0b11110100
                BYTE 0b00010100, 0b00010100
                BYTE 0b00000011, 0b01100000

; Third alien
sprite_a_3_0:   WORD 0x0208
                BYTE 0b00000001, 0b10000000
                BYTE 0b00000011, 0b11000000
                BYTE 0b00000111, 0b11100000
                BYTE 0b00001101, 0b10110000
                BYTE 0b00001111, 0b11110000
                BYTE 0b00000010, 0b01000000
                BYTE 0b00000101, 0b10100000
                BYTE 0b00001010, 0b01010000

sprite_a_3_1:   WORD 0x0208
                BYTE 0b00000001, 0b10000000
                BYTE 0b00000011, 0b11000000
                BYTE 0b00000111, 0b11100000
                BYTE 0b00001101, 0b10110000
                BYTE 0b00001111, 0b11110000
                BYTE 0b00000101, 0b10100000
                BYTE 0b00001000, 0b00010000
                BYTE 0b00000100, 0b00100000