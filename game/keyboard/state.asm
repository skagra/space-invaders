LEFT_KEY_DOWN_MASK:     EQU 0b00000001
RIGHT_KEY_DOWN_MASK:    EQU 0b00000010
FIRE_KEY_DOWN_MASK:     EQU 0b00000100
P1_KEY_DOWN_MASK:       EQU 0b00001000
P2_KEY_DOWN_MASK:       EQU 0b00010000
CREDS_KEY_DOWN_MASK:    EQU 0b00100000

LEFT_KEY_DOWN_BIT:      EQU 0
RIGHT_KEY_DOWN_BIT:     EQU 1
FIRE_KEY_DOWN_BIT:      EQU 2
P1_KEY_DOWN_BIT:        EQU 3
P2_KEY_DOWN_BIT:        EQU 4
CREDS_KEY_DOWN_BIT:     EQU 5

keys_down:              BLOCK 15
_fire_already_pressed:  BLOCK 1
_p1_already_pressed:    BLOCK 1
_p2_already_pressed:    BLOCK 1
_creds_already_pressed: BLOCK 1

PAUSE_KEY_DOWN_MASK:    EQU 0b10000000
PAUSE_KEY_DOWN_BIT:     EQU 7
_pause_already_pressed: BLOCK 1
