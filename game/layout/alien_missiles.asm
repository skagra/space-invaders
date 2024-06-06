; Alien to missile origin offset
ALIEN_MISSILE_OFFSET_X:         EQU 0x04 
ALIEN_MISSILE_OFFSET_Y:         EQU 0x08 
ALIEN_MISSILE_OFFSET_COORDS:    EQU (ALIEN_MISSILE_OFFSET_X<<8) + ALIEN_MISSILE_OFFSET_Y
ALIEN_MISSILE_MAX_Y:            EQU screen.SCREEN_HEIGHT_PIXELS-2*8-4    ; Y at which missile is considered to have hit the bottom of the screen
ALIEN_MISSILE_DELTA_DEFAULT:    EQU 0x04