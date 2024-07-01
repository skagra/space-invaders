; Values indicating which keys were pressed
LEFT_KEY_DOWN_MASK:     EQU 0b00000001
RIGHT_KEY_DOWN_MASK:    EQU 0b00000010
FIRE_KEY_DOWN_MASK:     EQU 0b00000100
P1_KEY_DOWN_MASK:       EQU 0b00001000
P2_KEY_DOWN_MASK:       EQU 0b00010000
CREDS_KEY_DOWN_MASK:    EQU 0b00100000
SPACE_KEY_DOWN_MASK:    EQU 0b01000000

LEFT_KEY_DOWN_BIT:      EQU 0
RIGHT_KEY_DOWN_BIT:     EQU 1
FIRE_KEY_DOWN_BIT:      EQU 2
P1_KEY_DOWN_BIT:        EQU 3
P2_KEY_DOWN_BIT:        EQU 4
CREDS_KEY_DOWN_BIT:     EQU 5
SPACE_KEY_DOWN_BIT:     EQU 6

; Values used to determine whether a key has been released since it was last pressed
_fire_already_pressed:  BLOCK 1
_p1_already_pressed:    BLOCK 1
_p2_already_pressed:    BLOCK 1
_creds_already_pressed: BLOCK 1
_space_already_pressed: BLOCK 1

; Combination of *_KEY_DOWN_MASKs indicating which keys were pressed
keys_down:              BLOCK 1