CHARACTER_SET_BASE:

; 32/0x20
CHAR_SP:    BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
    
    ; 42/0x2A
    ORG CHARACTER_SET_BASE+10*8

CHAR_AST:   BYTE 0b00000000
            BYTE 0b00010000
            BYTE 0b01010100
            BYTE 0b00111000
            BYTE 0b00010000
            BYTE 0b00111000
            BYTE 0b01010100
            BYTE 0b00010000

    ; 45/0x2D
    ORG CHARACTER_SET_BASE+13*8

CHAR_HYPHEN:
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000


    ; 48/0x30
    ORG CHARACTER_SET_BASE+16*8

CHAR_0:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01001100
            BYTE 0b01010100
            BYTE 0b01100100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_1:     BYTE 0b00000000
            BYTE 0b00010000
            BYTE 0b00110000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00111000

CHAR_2:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b00000100
            BYTE 0b00011000
            BYTE 0b00100000
            BYTE 0b01000000
            BYTE 0b01111100

CHAR_3:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000100
            BYTE 0b00001000
            BYTE 0b00011000
            BYTE 0b00000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_4:     BYTE 0b00000000
            BYTE 0b00001000
            BYTE 0b00011000
            BYTE 0b00101000
            BYTE 0b01001000
            BYTE 0b01111100
            BYTE 0b00001000
            BYTE 0b00001000

CHAR_5:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b01000000
            BYTE 0b01111000
            BYTE 0b00000100
            BYTE 0b00000100
            BYTE 0b01000100
            BYTE 0b01111000

CHAR_6:     BYTE 0b00000000
            BYTE 0b00011100
            BYTE 0b00100000
            BYTE 0b01000000
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_7:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000100
            BYTE 0b00001000
            BYTE 0b00010000
            BYTE 0b00100000
            BYTE 0b00100000
            BYTE 0b00100000

CHAR_8:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_9:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111100
            BYTE 0b00000100
            BYTE 0b00001000
            BYTE 0b01110000

    ; 60/0x3C
    ORG CHARACTER_SET_BASE+28*8
CHAR_LT:    BYTE 0b00000000
            BYTE 0b00001000
            BYTE 0b00010000
            BYTE 0b00100000
            BYTE 0b01000000
            BYTE 0b00100000
            BYTE 0b00010000
            BYTE 0b00001000

CHAR_EQ:    BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000000
            BYTE 0b00000000

CHAR_GT:    BYTE 0b00000000
            BYTE 0b00100000
            BYTE 0b00010000
            BYTE 0b00001000
            BYTE 0b00000100
            BYTE 0b00001000
            BYTE 0b00010000
            BYTE 0b00100000


    ; 63/0x3F
    ORG CHARACTER_SET_BASE+31*8

CHAR_QM:    BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b00001000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00000000
            BYTE 0b00010000

    ; 65/0x41
    ORG CHARACTER_SET_BASE+33*8
CHAR_A:     BYTE 0b00000000
            BYTE 0b00010000
            BYTE 0b00101000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111100
            BYTE 0b01000100
            BYTE 0b01000100

CHAR_B:     BYTE 0b00000000
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111000
CHAR_C:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_D:     BYTE 0b00000000
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111000

CHAR_E:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01111000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01111100

CHAR_F:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01111000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000

CHAR_G:     BYTE 0b00000000
            BYTE 0b00111100
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01001100
            BYTE 0b01000100
            BYTE 0b00111100

CHAR_H:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100

CHAR_I:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00111000

CHAR_J:     BYTE 0b00000000
            BYTE 0b00000100
            BYTE 0b00000100
            BYTE 0b00000100
            BYTE 0b00000100
            BYTE 0b00000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_K:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01001000
            BYTE 0b01010000
            BYTE 0b01100000
            BYTE 0b01010000
            BYTE 0b01001000
            BYTE 0b01000100

CHAR_L:     BYTE 0b00000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01111100

CHAR_M:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01101100
            BYTE 0b01010100
            BYTE 0b01010100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100

CHAR_N:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01100100
            BYTE 0b01010100
            BYTE 0b01001100
            BYTE 0b01000100
            BYTE 0b01000100

CHAR_O:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_P:     BYTE 0b00000000
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111000
            BYTE 0b01000000
            BYTE 0b01000000
            BYTE 0b01000000

CHAR_Q:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01010100
            BYTE 0b01001000
            BYTE 0b00110100

CHAR_R:     BYTE 0b00000000
            BYTE 0b01111000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01111000
            BYTE 0b01010000
            BYTE 0b01001000
            BYTE 0b01000100

CHAR_S:     BYTE 0b00000000
            BYTE 0b00111000
            BYTE 0b01000100
            BYTE 0b01000000
            BYTE 0b00111000
            BYTE 0b00000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_T:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000

CHAR_U:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00111000

CHAR_V:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00101000
            BYTE 0b00010000

CHAR_W:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b01010100
            BYTE 0b01010100
            BYTE 0b01101100
            BYTE 0b01000100

CHAR_X:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00101000
            BYTE 0b00010000
            BYTE 0b00101000
            BYTE 0b01000100
            BYTE 0b01000100

CHAR_Y:     BYTE 0b00000000
            BYTE 0b01000100
            BYTE 0b01000100
            BYTE 0b00101000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000

CHAR_Z:     BYTE 0b00000000
            BYTE 0b01111100
            BYTE 0b00000100
            BYTE 0b00001000
            BYTE 0b00010000
            BYTE 0b00100000
            BYTE 0b01000000
            BYTE 0b01111100

; Mapped from "["
CHAR_IY:    BYTE 0b00000000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00010000
            BYTE 0b00101000
            BYTE 0b01000100
            BYTE 0b01000100

