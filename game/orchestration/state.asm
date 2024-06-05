
; The main game loop is running - FALSE => game over
_game_running:                  BLOCK 1

; An alien is exploding, the game briefly pauses
_alien_exploding:               BLOCK 1

; And alien has landed
_alien_landed:                  BLOCK 1

; The game is paused while player explodes
; either after being hit by a missile or an alien has landed
_life_lost_pausing:             BLOCK 1

; Count down for game pause while alien explodes
_alien_exploding_count_down:    BLOCK 1

; Count down for game pause while player explodes
_life_lost_pause_count_down:    BLOCK 1