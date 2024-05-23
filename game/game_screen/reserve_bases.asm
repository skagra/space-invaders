draw_reserve_bases:
    PUSH DE

    LD D,._RESERVE_BASE_1_X
    LD E,layout.RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    LD D,._RESERVE_BASE_2_X
    LD E,layout.RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    POP DE

    RET

._RESERVE_BASE_1_X:   EQU layout.RESERVE_BASE_START_X
._RESERVE_BASE_2_X:   EQU ._RESERVE_BASE_1_X+layout.RESERVE_BASE_OFFSET_X

draw_reserve_base:

.PARAM_COORDS:  EQU 6

    PUSH DE,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+.PARAM_COORDS)             
    PUSH DE     
    LD DE,sprites.PLAYER_DIMS
    PUSH DE
    LD DE,sprites.PLAYER     
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET