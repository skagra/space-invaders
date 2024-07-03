;------------------------------------------------------------------------------
; Draw the player base or explosion based on _player_state
; 
; Usage:
;   CALL draw
;------------------------------------------------------------------------------

draw:
    PUSH AF,DE

    LD A,(_player_state)
    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR NZ,.draw_explosion

    CALL _draw_player

    JR .done

.draw_explosion
    CALL _draw_explosion
    ; Fall through

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the player base 
; 
; Usage:
;   CALL _draw_player
;------------------------------------------------------------------------------
_draw_player:
    PUSH AF,DE

    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, layout.PLAYER_Y
    PUSH DE
      
    LD DE,sprites.PLAYER                                ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    CALL fast_draw.draw_sprite_16x8                     ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Draw the player base explosion 
; 
; Usage:
;   CALL _draw_explosion
;------------------------------------------------------------------------------

_draw_explosion:
    PUSH AF,DE

    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, layout.PLAYER_Y
    PUSH DE
      
    LD DE,(_player_explosion_variant_sprite)            ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    CALL fast_draw.draw_sprite_16x8                     ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the player base or explosion based on _player_state
; 
; Usage:
;   CALL blank
;------------------------------------------------------------------------------

blank:
    PUSH AF,DE

    LD A,(_player_state)
    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    BIT _PLAYER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    CALL _blank_player

    JR .done

.blank_explosion   
    CALL _blank_explosion
    ; Fall through

.done
    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the player base 
; 
; Usage:
;   CALL _blank_player
;------------------------------------------------------------------------------

_blank_player:
    PUSH AF,DE

    LD A, (player_x)                                    ; Coords
    LD D,A
    LD E, layout.PLAYER_Y
    PUSH DE

    LD DE,sprites.PLAYER                                ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE 

    CALL fast_draw.draw_sprite_16x8                     ; Erase the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET

;------------------------------------------------------------------------------
; Blank the player base explosion
; 
; Usage:
;   CALL _blank_explosion
;------------------------------------------------------------------------------

_blank_explosion:
    PUSH AF,DE

    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, layout.PLAYER_Y
    PUSH DE
      
    LD DE,(_player_explosion_variant_sprite)            ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH DE

    CALL fast_draw.draw_sprite_16x8                     ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET