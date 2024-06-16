;------------------------------------------------------------------------------
; Draw the player base
; 
; Usage:
;   CALL draw
;------------------------------------------------------------------------------

draw:
    PUSH AF,DE

    LD A,(_player_state)
    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR NZ,.draw_explosion

    ; Draw the player base sprite
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

    JR .done

.draw_explosion
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

.done
    POP DE,AF

    RET

blank:
    PUSH AF,DE

    LD A,(_player_state)
    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    BIT _PLAYER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    ; Erase the player base sprite
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

    JR .done

.blank_explosion   
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

.done
    POP DE,AF

    RET