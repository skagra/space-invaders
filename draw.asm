    MODULE draw

; usage PUSH color
fill_screen:
    PUSH HL,IX    

    ; Erase contents of screen
    LD HL,0x0000
    PUSH HL
    LD HL,mmap.SCREEN_START
    PUSH HL
    LD HL, mmap.SCREEN_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL,HL,HL

    ; Fill screen with the given colour
    LD  IX,0
    ADD IX,SP
    LD HL, (ix+7)    ; get the bg colour from the stack
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_START
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL,HL,HL 

    POP IX,HL
    RET

    ENDMODULE

