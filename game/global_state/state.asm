; Global game state taken from GAME_STATE_* values
_game_state: BLOCK 1

_GAME_STATE_RUNNING_VALUE:          EQU 0b00000001      ; Normal game running state
_GAME_STATE_ALIEN_EXPLODING_VALUE:  EQU 0b00000010      ; An alien has been hit by player missile and is exploding
_GAME_STATE_GAME_OVER_VALUE:        EQU 0b00000100

_GAME_STATE_RUNNING_BIT:            EQU 0
_GAME_STATE_ALIEN_EXPLODING_BIT:    EQU 1
_GAME_STATE_GAME_OVER_BIT:          EQU 2

_alien_exploding_count_down:        BLOCK 1             ; Cycles left to pauseable while alien explodes