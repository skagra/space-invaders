slow_print_string:
    
.PARAM_STRING_PTR:  EQU 16
.PARAM_COORDS:      EQU 14
.PARAM_CALLBACK:    EQU 12 

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_CALLBACK)
    LD (.cb),HL

    ; Calculate memory location from coords
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL char_coords_to_mem
    POP HL                                              ; Grab return value - screen address
    POP DE        

    LD DE,(IX+.PARAM_STRING_PTR)                        ; Pointer to current character

.character_loop:
    ; Get character to print
    LD A,(DE)                                           ; Have we hit the end of the string?
    AND A
    JR Z,.ps_done

    LD B,0x00                                           ; Character to print
    LD C,A
    PUSH BC
    
    PUSH HL                                             ; On-screen address                                    

    CALL _print_char_at_screen_mem                      ; Print character

    POP BC                                              ; Result
    POP BC                                              ; Ditch the parameter

    INC DE                                              ; Move to the next character
    INC HL                                              ; Next screen address

    CALL draw.flush_buffer_to_screen 
    
    LD B,.PRINT_DELAY

.delay_loop:
    PUSH HL
    PUSH HL
.cb+1:   
     CALL 0x0000
     POP HL
     BIT utils.TRUE_BIT,L
     POP HL
     JR Z,.ps_done

    HALT
    
    DJNZ .delay_loop

    JR .character_loop                                  ; Next character

.ps_done:
    POP IX,HL,DE,BC,AF

    RET

.PRINT_DELAY: EQU 10

slow_print_null_callback:

.RTN_VALUE: EQU 4

    PUSH IX

    LD IX,0; Get the stack pointer
    ADD IX,SP

    LD (IX+.RTN_VALUE),utils.TRUE_VALUE

    POP IX

    RET
