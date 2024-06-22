draw_shields:
    PUSH DE

    LD D,layout.SHIELD_1_X
    LD E,layout.SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    LD D,layout.SHIELD_2_X
    LD E,layout.SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    LD D,layout.SHIELD_3_X
    LD E,layout.SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    LD D,layout.SHIELD_4_X
    LD E,layout.SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    POP DE

    RET

draw_shield:

.PARAM_COORDS:  EQU 0

    PUSH DE,IX

    PARAMS_IX 2                                         ; Get the stack pointer
 
    LD DE,(IX+.PARAM_COORDS)             
    PUSH DE     
    LD DE,sprites.SHIELD_DIMS
    PUSH DE
    LD DE,sprites.SHIELD     
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET