;------------------------------------------------------------------------------
;
; Erase the screen
;
; Usage:
;   CALL wipe_screen
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

wipe_screen:
    PUSH HL,IX    

    ; Set up call to utils.fill_mem
    LD HL,0x0000                                        ; Fill with zero values (blank)
    PUSH HL
    LD HL,memory_map.SCREEN_START                       ; Start of screen area
    PUSH HL
    LD HL,memory_map.SCREEN_SIZE                        ; Length of screen area
    PUSH HL
    CALL utils.fill_mem                                 ; Erase the screen
    POP HL                                              ; Ditch the supplied parameters
    POP HL
    POP HL

    IFNDEF DIRECT_DRAW
         ; Set up call to utils.fill_mem
        LD HL,0x0000                                    ; Fill with zero values (blank)
        PUSH HL
        LD HL,double_buffer.OFF_SCREEN_BUFFER_START     ; Start of off-screen buffer
        PUSH HL
        LD HL,memory_map.SCREEN_SIZE                    ; Length of screen area
        PUSH HL
        CALL utils.fill_mem                             ; Erase the screen
        POP HL                                          ; Ditch the supplied parameters
        POP HL
        POP HL 
    ENDIF

    POP IX,HL

    RET



