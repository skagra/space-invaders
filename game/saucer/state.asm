; Saucer states

_SAUCER_STATE_NO_SAUCER_VALUE:          EQU 0b00000001          ; No active saucer
_SAUCER_STATE_ACTIVE_VALUE:             EQU 0b00000010          ; Active saucer
_SAUCER_STATE_EXPLODING_VALUE:          EQU 0b00000100          ; Saucer is exploding
_SAUCER_STATE_DONE_EXPLODING_VALUE:     EQU 0b00001000          ; Explosion completed
_SAUCER_STATE_LEAVING_SCREEN_VALUE:     EQU 0b00010000          ; Saucer has reached a screen edge
_SAUCER_STATE_SHOWING_SCORE_VALUE:      EQU 0b00100000          ; Showing the "mystery" saucer score
_SAUCER_STATE_DONE_SHOWING_SCORE_VALUE: EQU 0b01000000          ; Done showing saucer score

_SAUCER_STATE_NO_SAUCER_BIT:            EQU 0
_SAUCER_STATE_ACTIVE_BIT:               EQU 1
_SAUCER_STATE_EXPLODING_BIT:            EQU 2
_SAUCER_STATE_DONE_EXPLODING_BIT:       EQU 3
_SAUCER_LEAVING_SCREEN_BIT:             EQU 4
_SAUCER_STATE_SHOWING_SCORE_BIT:        EQU 5
_SAUCER_STATE_DONE_SHOWING_SCORE_BIT:   EQU 6

_saucer_state:                          BLOCK 1                 ; Current saucer state
_saucer_x:                              BLOCK 1                 ; Current saucer x coordinate

; Scores for hitting a saucer, indexed by the bottom 4 bits of shot count.   
; BCD values/10 - so actual values range from 50 to 300
SAUCER_SCORES:                          BYTE 0x10,0x05,0x05,0x10,0x15,0x10,0x10,0x05
                                        BYTE 0x30,0x10,0x10,0x10,0x05,0x15,0x10,0x05 

enabled:                                BLOCK 1                 ; Is saucer launching enabled
timer_enabled:                          BLOCK 1                 ; Is counter to launch time enabled

_saucer_timer:                          BLOCK 2

; How often the saucer is launched game loops (VSYNC) MSB
_SAUCER_LAUNCH_GAME_LOOP_FREQUENCY:     EQU 0x06

; Saucer X start and bounds
_SAUCER_MAX_X:                          EQU screen.SCREEN_WIDTH_PIXELS-(sprites.SAUCER_DIM_X_BYTES*8)-layout.INSET_X_PIXELS
_SAUCER_MIN_X:                          EQU layout.INSET_X_PIXELS
_SAUCER_START_LEFT:                     EQU layout.INSET_X_PIXELS 
_SAUCER_START_RIGHT:                    EQU screen.SCREEN_WIDTH_PIXELS-(sprites.SAUCER_DIM_X_BYTES*8)-layout.INSET_X_PIXELS

; Saucer movement direction
_DIRECTION_LEFT_VALUE:                  EQU 0b00000001
_DIRECTION_RIGHT_VALUE:                 EQU 0b00000010
_DIRECTION_LEFT_BIT:                    EQU 0
_DIRECTION_RIGHT_BIT:                   EQU 1

_direction:                             BLOCK 1

; Count down for saucer explosion and display of score
exploding_counter:                      BLOCK 1
showing_score_counter:                  BLOCK 1

; Current value of "mystery" score
_score:                                 BLOCK 2

; Number of cyckes to hold explosion and score
_EXPLOSION_CYCLE_COUNT:                 EQU 30
_SCORE_CYCLE_COUNT:                     EQU 30