print_continue:
    PUSH HL
    
    ; Green strip for "Press Space" message
    LD H,0x17                                           ; TODO Pull out into a constant
    LD L,1
    PUSH HL
    LD L,colours.CA_BG_BLACK | colours.CA_FG_GREEN 
    PUSH HL
    CALL colours.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Space to continue text
    LD HL,CONTINUE_TEXT
    PUSH HL
    LD HL,0x0417                                        ; TODO Pull out into a constant
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    POP HL

    RET
    
CONTINUE_TEXT: BYTE "<Press space to continue>",0