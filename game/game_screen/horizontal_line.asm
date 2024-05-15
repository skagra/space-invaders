draw_horizontal_line:
    PUSH AF,BC,DE,HL

    LD B,layout.INSET_X_PIXELS
    LD C,layout.HORIZONTAL_LINE_Y

    LD L,layout.INSET_SCREEN_WIDTH_CHARS

.loop       
    PUSH BC 
    LD DE,sprites.HORIZ_LINE_DIMS
    PUSH DE
    LD DE,sprites.HORIZ_LINE    
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
    POP DE
    POP DE
    POP DE

    LD A,0x08
    ADD A,B
    LD B,A

    DEC L
    JR NZ,.loop

    POP HL,DE,BC,AF

    RET

