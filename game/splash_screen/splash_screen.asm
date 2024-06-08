draw_splash_screen:
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

.MESSAGE_TEXT_0: BYTE " An authentic clone of Taito's  ",0
.MESSAGE_TEXT_1: BYTE "   1978 Space Invaders game.    ",0
.MESSAGE_TEXT_2: BYTE "   For the ZX Spectrum 48K.     ",0
.MESSAGE_TEXT_3: BYTE "           By Skagra            ",0
.MESSAGE_TEXT_4: BYTE "   https://github.com/skagra/   ",0

.MESSAGE: 
    WORD 0x000E, .MESSAGE_TEXT_0
    WORD 0x000F, .MESSAGE_TEXT_1
    WORD 0x0011, .MESSAGE_TEXT_2
    WORD 0x0013, .MESSAGE_TEXT_3
    WORD 0x0015, .MESSAGE_TEXT_4

.MESSAGE_LINES_COUNT: EQU ($-.MESSAGE)/4