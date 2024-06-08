draw_controls_screen:
    PUSH AF,HL

    ; Wipe screens
    CALL draw_utils.wipe_screen
    
    ; Mostly black and white
    LD L,colours.CA_BG_BLACK | colours.CA_FG_WHITE
    PUSH HL
    CALL colours.fill_screen_attributes
    POP HL

    ; Black border
    LD HL,colours.BORDER_BLACK
    PUSH HL
    CALL colours.set_border    
    POP HL

    ; Draw the "Space Invaders" graphic header
    CALL draw_header

    ; Use the ROM font so we can have lower case
    LD HL,print.CHARACTER_SET_SPECTRUM
    PUSH HL
    CALL print.set_font
    POP HL

    ; Print the continue line
    CALL print_continue

    ; Slow print the main message
    LD HL,.MESSAGE_LINES_COUNT
    PUSH HL                        
    LD HL,.MESSAGE
    PUSH HL
    CALL print_message
    POP HL
    POP HL

    ; Space pressed during slow print?
    LD A,(_next_screen)
    BIT utils.TRUE_BIT,A
    JR NZ,.done

    ; Wait for space to be pressed
    LD L,keyboard.PAUSE_KEY_DOWN_MASK
    PUSH HL
    CALL keyboard.wait
    POP HL
    
.done
    POP HL,AF

    RET

.MESSAGE_TEXT_0: BYTE "Controls ",0
.MESSAGE_TEXT_1: BYTE "5     - Add credit",0
.MESSAGE_TEXT_2: BYTE "1     - Single player",0
.MESSAGE_TEXT_3: BYTE "A     - Move left",0
.MESSAGE_TEXT_4: BYTE "S     - Move right ",0
.MESSAGE_TEXT_5: BYTE "Enter - Fire",0

.MESSAGE: 
    WORD 0x0B0E, .MESSAGE_TEXT_0
    WORD 0x0510, .MESSAGE_TEXT_1
    WORD 0x0511, .MESSAGE_TEXT_2
    WORD 0x0512, .MESSAGE_TEXT_3
    WORD 0x0513, .MESSAGE_TEXT_4
    WORD 0x0514, .MESSAGE_TEXT_5

.MESSAGE_LINES_COUNT: EQU ($-.MESSAGE)/4