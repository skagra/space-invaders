wipe_play_area:

    PUSH HL,IX    

    ; Set up call to utils.fill_mem
    LD HL,0x0000                                        ; Fill with zero values (blank)
    PUSH HL
    LD HL,memory_map.SCREEN_START+draw_common.SCREEN_WIDTH_PIXELS*1 ; Start of screen area + 2 rows
    PUSH HL
    LD HL,memory_map.SCREEN_SIZE-draw_common.SCREEN_WIDTH_PIXELS*1                       ; Length of screen area
    PUSH HL
    CALL utils.fill_mem                                 ; Erase the screen
    POP HL                                              ; Ditch the supplied parameters
    POP HL
    POP HL

    IFNDEF DIRECT_DRAW
         ; Set up call to utils.fill_mem
        LD HL,0x0000                                    ; Fill with zero values (blank)
        PUSH HL
        LD HL,draw_common.OFF_SCREEN_BUFFER_START+draw_common.SCREEN_WIDTH_PIXELS*1  ; Start of off-screen buffer + 2 rows
        PUSH HL
        LD HL,memory_map.SCREEN_SIZE-draw_common.SCREEN_WIDTH_PIXELS*1                   ; Length of screen area
        PUSH HL
        CALL utils.fill_mem                             ; Erase the screen
        POP HL                                          ; Ditch the supplied parameters
        POP HL
        POP HL 
    ENDIF

    POP IX,HL

    RET