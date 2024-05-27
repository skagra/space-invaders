; Offsets into the alien missile struct
_ALIEN_MISSILE_OFFSET_COORDS:                           EQU 0                   ; Coordinates
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0:                 EQU 2                   ; First sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_1:                 EQU 4                   ; Second sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_2:                 EQU 6                   ; Third sprite variant
_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_3:                 EQU 8                   ; Fourth sprite variant
_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT:                  EQU 10                  ; Current variant (from _ALIEN_MISSILE_VARIANT_?)
_ALIEN_MISSILE_OFFSET_STATE:                            EQU 11                  ; State (from _ALIEN_MISSILE_STATE_VALUE_*)
_ALIEN_MISSILE_OFFSET_EXPLOSION_COUNT_DOWN:             EQU 12                  ; Count down when the missile is exploding at the bottom of the screen
_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT:                EQU 13                  ; Number of active steps taken - used as part of the reload algorithm
_ALIEN_MISSILE_OFFSET_SHOT_COLUMN_INDEX:                EQU 14                  ; Index into relevant SHOT_COLUMNS_? table for the next column to fire from
_ALIEN_MISSILE_OFFSET_TYPE:                             EQU 15           

_ALIEN_MISSILE_STRUCT_SIZE:                             EQU 16                  ; Size of the entire struct in bytes


; Alien missile states
_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE:                  EQU 0b00000001          ; The missile is not active
_ALIEN_MISSILE_STATE_ACTIVE_VALUE:                      EQU 0b00000010          ; Nominal state moving down screen
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_VALUE:    EQU 0b00000100          ; Reached the bottom of the screen
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_VALUE:         EQU 0b00001000          ; At the bottom of the screen (exploding)
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_VALUE:    EQU 0b00010000          ; Done (exploding) at the bottom of the screen
_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE:                  EQU 0b00100000          ; Hit a shield

; Bit positions correspond to each of the states
_ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT:                    EQU 0                   ; Missile is not active
_ALIEN_MISSILE_STATE_ACTIVE_BIT:                        EQU 1                   ; Nominal state moving down screen
_ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT:      EQU 2                   ; Reached the bottom of the screen
_ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_BIT:           EQU 3                   ; At the bottom of the screen (exploding)
_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT:      EQU 4                   ; Done (exploding) at the bottom of the screen
_ALIEN_MISSILE_STATE_HIT_SHIELD_BIT:                    EQU 5                   ; Hit a shield

; Values to indicate current missile sprite variant
_ALIEN_MISSILE_VARIANT_0:                               EQU 0
_ALIEN_MISSILE_VARIANT_1:                               EQU 1
_ALIEN_MISSILE_VARIANT_2:                               EQU 2
_ALIEN_MISSILE_VARIANT_3:                               EQU 3
_ALIEN_MISSILE_VARIANT_COUNT:                           EQU 4

; Three alien missiles
_ALIEN_MISSILE_0: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_0_VARIANT_0,sprites.ALIEN_MISSILE_0_VARIANT_1,sprites.ALIEN_MISSILE_0_VARIANT_2,sprites.ALIEN_MISSILE_0_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE,0x00,0x00,0x00,_ALIEN_MISSILE_TYPE_0
_ALIEN_MISSILE_1: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_1_VARIANT_0,sprites.ALIEN_MISSILE_1_VARIANT_1,sprites.ALIEN_MISSILE_1_VARIANT_2,sprites.ALIEN_MISSILE_1_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE,0x00,0x00,0x00,_ALIEN_MISSILE_TYPE_1
_ALIEN_MISSILE_2: WORD 0x0000
                  WORD sprites.ALIEN_MISSILE_2_VARIANT_0,sprites.ALIEN_MISSILE_2_VARIANT_1,sprites.ALIEN_MISSILE_2_VARIANT_2,sprites.ALIEN_MISSILE_2_VARIANT_3 
                  BYTE _ALIEN_MISSILE_VARIANT_0, _ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE,0x00,0x00,0x00,_ALIEN_MISSILE_TYPE_2

; Values to flag each of the three alien missiles
_ALIEN_MISSILE_TYPE_0:                                  EQU 0                                               
_ALIEN_MISSILE_TYPE_1:                                  EQU 1                                                   
_ALIEN_MISSILE_TYPE_2:                                  EQU 2               

_ALIEN_MISSILE_TYPE_COUNT:                              EQU 3

; Nominal number of pixels to move a missile each cycle
_ALIEN_MISSILE_DELTA_Y:                                 EQU 3

; Pointer to the current missile struct
_current_alien_missile_ptr:                             BLOCK 2

_ALIEN_MISSILES_GLOBAL_STATE_ACTIVE_VALUE:              EQU 0b00000001
_ALIEN_MISSILES_GLOBAL_STATE_PAUSED_VALUE:              EQU 0b00000010

_ALIEN_MISSILES_GLOBAL_STATE_ACTIVE_BIT:                EQU 0
_ALIEN_MISSILES_GLOBAL_STATE_PAUSED_BIT:                EQU 1

_alien_missiles_global_state:                           BLOCK 1