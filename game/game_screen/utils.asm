wipe_play_area:

    PUSH HL    

    ; Set up call to utils.fill_mem
    LD HL,0x0000                                        ; Fill with zero values (blank)
    PUSH HL
    LD HL,memory_map.SCREEN_START+screen.SCREEN_WIDTH_PIXELS*1 ; Start of screen area + 2 rows
    PUSH HL
    LD HL,memory_map.SCREEN_SIZE-screen.SCREEN_WIDTH_PIXELS*1                       ; Length of screen area
    PUSH HL
    CALL utils.fill_mem                                 ; Erase the screen
    POP HL                                              ; Ditch the supplied parameters
    POP HL
    POP HL

    IFNDEF DIRECT_DRAW
         ; Set up call to utils.fill_mem
        LD HL,0x0000                                    ; Fill with zero values (blank)
        PUSH HL
        LD HL,double_buffer.OFF_SCREEN_BUFFER_START+screen.SCREEN_WIDTH_PIXELS*1    ; Start of off-screen buffer + 2 rows
        PUSH HL
        LD HL,memory_map.SCREEN_SIZE-screen.SCREEN_WIDTH_PIXELS*1                   ; Length of screen area
        PUSH HL
        CALL utils.fill_mem                             ; Erase the screen
        POP HL                                          ; Ditch the supplied parameters
        POP HL
        POP HL 
    ENDIF

    POP HL

    RET