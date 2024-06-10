draw:
    PUSH AF,DE

    LD A,(_saucer_state)
    BIT _SAUCER_STATE_EXPLODING_BIT,A
    JR NZ,.draw_explosion

    ; Draw the saucer
    LD A, (saucer_x)                                    ; Saucer base coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.draw_explosion
    LD A, (saucer_x)                                    ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE                              ; Drawing
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET

blank:
    PUSH AF,DE

    LD A,(_saucer_state)

    BIT _SAUCER_STATE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    BIT _SAUCER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.blank_explosion

    ; Blank the saucer
    LD A, (saucer_x)                                    ; Saucer base coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE

    LD DE,sprites.SAUCER_DIMS
    PUSH DE

    LD DE,sprites.SAUCER                                ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the saucer
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.blank_explosion
    LD A, (saucer_x)                                    ; Saucer coords
    LD D,A
    LD E, layout.SAUCER_Y
    PUSH DE
      
    LD DE,sprites.SAUCER_EXPLOSION_DIMS                 ; Dimensions
    PUSH DE

    LD DE,sprites.SAUCER_EXPLOSION                      ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE                               ; Blanking
    PUSH DE

    LD DE,collision.dummy_collision                     ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                               ; Draw the player base sprite
    
    POP DE 
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET