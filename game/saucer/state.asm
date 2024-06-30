_SAUCER_STATE_NO_SAUCER_VALUE:          EQU 0b00000001
_SAUCER_STATE_ACTIVE_VALUE:             EQU 0b00000010
_SAUCER_STATE_EXPLODING_VALUE:          EQU 0b00000100
_SAUCER_STATE_DONE_EXPLODING_VALUE:     EQU 0b00001000
_SAUCER_STATE_LEAVING_SCREEN_VALUE:     EQU 0b00010000
_SAUCER_STATE_SHOWING_SCORE:            EQU 0b00100000
_SAUCER_STATE_DONE_SHOWING_SCORE:       EQU 0b01000000

_SAUCER_STATE_NO_SAUCER_BIT:            EQU 0
_SAUCER_STATE_ACTIVE_BIT:               EQU 1
_SAUCER_STATE_EXPLODING_BIT:            EQU 2
_SAUCER_STATE_DONE_EXPLODING_BIT:       EQU 3
_SAUCER_LEAVING_SCREEN_BIT:             EQU 4
_SAUCER_STATE_SHOWING_SCORE_BIT:        EQU 5
_SAUCER_STATE_DONE_SHOWING_SCORE_BIT:   EQU 6
_saucer_state:                          BLOCK 1
saucer_x:                               BLOCK 1

; Scores for hitting a saucer, indexed by the bottom 4 bits of shot count.   
; BCD values/10 - so actual values range from 50 to 300
SAUCER_SCORES:                          BYTE 0x10,0x05,0x05,0x10,0x15,0x10,0x10,0x05
                                        BYTE 0x30,0x10,0x10,0x10,0x05,0x15,0x10,0x05 

enabled:                                BLOCK 1
timer_enabled:                          BLOCK 1

saucer_timer:                           BLOCK 2

; How often the saucer is launched game loops (VSYNC) MSB
;SAUCER_LAUNCH_GAME_LOOP_FREQUENCY:      EQU 0x06

SAUCER_LAUNCH_GAME_LOOP_FREQUENCY:      EQU 0x01

_SAUCER_MAX_X:                          EQU screen.SCREEN_WIDTH_PIXELS-(sprites.SAUCER_DIM_X_BYTES*8)-layout.INSET_X_PIXELS
_SAUCER_MIN_X:                          EQU layout.INSET_X_PIXELS
_SAUCER_START_LEFT:                     EQU layout.INSET_X_PIXELS 
_SAUCER_START_RIGHT:                    EQU screen.SCREEN_WIDTH_PIXELS-(sprites.SAUCER_DIM_X_BYTES*8)-layout.INSET_X_PIXELS

_direction:                             BLOCK 1

_DIRECTION_LEFT_VALUE:                  EQU 0b00000001
_DIRECTION_RIGHT_VALUE:                 EQU 0b00000010

_DIRECTION_LEFT_BIT:                    EQU 0
_DIRECTION_RIGHT_BIT:                   EQU 1