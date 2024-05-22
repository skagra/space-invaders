;------------------------------------------------------------------------------
;
; Draw the player base
; 
; Usage:
;   CALL process_player
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

draw:
    PUSH AF,DE

    ; Draw the player base sprite
    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, layout.PLAYER_BASE_Y
    PUSH DE
      
    LD DE,sprites.PLAYER_BASE                           ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    CALL fast_draw.draw_sprite_16x8                     ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET

blank:
    PUSH AF,DE

    ; Erase the player base sprite
    LD A, (player_x)                                    ; Coords
    LD D,A
    LD E, layout.PLAYER_BASE_Y
    PUSH DE

    LD DE,sprites.PLAYER_BASE                           ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE 

    CALL fast_draw.draw_sprite_16x8                     ; Erase the player base sprite
    
    POP DE 
    POP DE
    POP DE

    POP DE,AF

    RET