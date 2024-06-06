print_score_player_1:
    PUSH HL

    LD HL,(scoring.score_player_1)                      ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_PLAYER_1_CHAR_COORDS             ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET

flash_score_player_1:
    PUSH BC,HL

    LD B,.FLASH_PLAYER_SCORE_CYCLES

.flash_loop
    CALL print_score_player_1

    HALT
    HALT
    HALT
    HALT
    HALT
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.SCORE_BLANK_STRING
    PUSH HL
    LD HL,layout.SCORE_PLAYER_1_CHAR_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    HALT
    HALT
    HALT
    HALT
    HALT
    CALL double_buffer.flush_buffer_to_screen

    DJNZ .flash_loop

    POP HL,BC

    RET

; Arcade machine flashes ~22 times over a period of  ~4 seconds
.SCORE_BLANK_STRING:        BYTE "    ",0
.FLASH_PLAYER_SCORE_CYCLES: EQU 22

print_score_player_2:
    PUSH HL

    LD HL,(scoring.score_player_2)                      ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_PLAYER_2_CHAR_COORDS             ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET

print_score_high:
    PUSH HL

    LD HL,(scoring.score_high)                          ; Grab the current score
    PUSH HL                                             
    LD HL,layout.SCORE_HIGH_CHAR_COORDS                 ; Coords for score
    PUSH HL
    CALL print.print_bcd_word                           ; Print the score to the screen
    POP HL
    POP HL
    
    POP HL

    RET

print_scores:
    CALL print_score_high                               ; High score
    CALL print_score_player_1  
    
    RET

print_scores_section:
    PUSH HL

    ; Draw static screen labels
    LD HL,.SCORE_LINE_0_TEXT
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    ; Draw the scores
    CALL print_scores
    CALL double_buffer.flush_buffer_to_screen

    POP HL

    RET

.SCORE_LINE_0_TEXT:         BYTE "   SCORE<1> HI-SCORE SCORE<2>",0