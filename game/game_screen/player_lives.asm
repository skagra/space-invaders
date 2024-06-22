draw_bases:
    PUSH AF,BC,DE,HL

    ; Lives
    LD A,(player_lives.player_lives_1)
    LD B,A

    ; Coords
    LD H,layout.RESERVE_BASE_START_X
    LD L,layout.RESERVE_BASE_Y

    ; Draw or blank the first (high count) base
    PUSH HL                             ; Coords

    LD A,B                              ; <2 bases?
    CP 0x02
    JR NC,.draw_high_base               ; No - so draw a base
    LD DE,utils.TRUE_VALUE             ; Yes - so blank the base
    PUSH DE
    JR .draw_1

.draw_high_base:
    LD DE,utils.FALSE_VALUE
    PUSH DE

.draw_1:
    CALL _draw_base
    POP DE
    POP DE

    ; Draw or blank the second (low count) base
    LD A,H                              ; Coords
    ADD layout.RESERVE_BASE_OFFSET_X
    LD H,A
    PUSH HL

    LD A,B
    CP 0x03                             ; Are there exactly 2 bases?
    JR Z,.draw_low_base                 ; Yes - so draw
    LD DE,utils.TRUE_VALUE              
    ; No - so blank
    PUSH DE
    JR .draw_2

.draw_low_base:
    LD DE,utils.FALSE_VALUE
    PUSH DE

.draw_2:
    CALL _draw_base
    POP DE
    POP DE

.done
    POP HL,DE,BC,AF

    RET

_draw_base:

.PARAM_COORDS:  EQU 2
.PARAM_BLANK:   EQU 0

    PUSH DE,IX

    PARAMS_IX 2                                         ; Get the stack pointer
  
    LD DE,(IX+.PARAM_COORDS)             
    PUSH DE     
    LD DE,sprites.PLAYER_DIMS
    PUSH DE
    LD DE,sprites.PLAYER     
    PUSH DE
    LD DE,(IX+.PARAM_BLANK)
    PUSH DE
    LD DE,collision.dummy_collision
    PUSH DE

    CALL draw.draw_sprite

    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

print_bases_count:
    PUSH AF,HL

    LD A,(player_lives.player_lives_1)
    LD H,0x00
    LD L,A
    PUSH HL

    LD HL,layout.PLAYER_COUNT_CHAR_COORDS
    PUSH HL

    CALL print.print_bcd_nibble

    POP HL
    POP HL
    
    POP HL,AF

    RET

draw_player_lives_section:
    ; Draw count of remaining bases
    CALL print_bases_count
    CALL double_buffer.flush_buffer_to_screen

    ; Draw graphic of remaining bases                              
    CALL draw_bases                                     
    CALL double_buffer.flush_buffer_to_screen
    
    RET
