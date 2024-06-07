; Colours 1 -> 8
; Rows 0->C
colour_cycle:
    PUSH AF,BC,HL

    LD A,(start_colour)
    LD C,A
    LD B,0x0C
.loop
    LD H,B
    LD L,1
    PUSH HL
    LD A,C
    OR colours.CA_BG_BLACK
    LD L,A
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    INC C
    LD A,C
    CP 0x08
    JR NZ,.dont_reset_colour
    LD C,0x01

.dont_reset_colour
    HALT

    DJNZ .loop

    LD A,C
    LD (start_colour),A
  
    POP HL,BC,AF

    RET

start_colour: BLOCK 1