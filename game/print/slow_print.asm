slow_print_string:
    
.PARAM_STRING_PTR:  EQU 16
.PARAM_COORDS:      EQU 14
.PARAM_CALLBACK:    EQU 12 

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_CALLBACK)                          ; Self modifying code to call the callback
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
    LD A,(DE)                                           ; Get character to print
    AND A                                               ; Have we hit the end of the string?
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
    
    LD B,.PRINT_DELAY                                   ; Number of loops to delay for

.delay_loop:
    PUSH HL                                             ; Save HL
    PUSH HL                                             ; Make space for the return value
.cb+1:   
     CALL 0x0000                                        ; Address modified to point to callback
     POP HL                                             ; Return value
     BIT utils.TRUE_BIT,L                               ; Continue?
     POP HL                                             ; Restore HL
     JR Z,.ps_done                                      ; Done if callback flagged done

    HALT                                                ; Delay for a one VSYNC
    
    DJNZ .delay_loop

    JR .character_loop                                  ; Next character

.ps_done:
    POP IX,HL,DE,BC,AF

    RET

.PRINT_DELAY: EQU 5

slow_print_null_callback:

.RTN_VALUE: EQU 4

    PUSH IX

    LD IX,0                                             ; Get the stack pointer
    ADD IX,SP

    LD (IX+.RTN_VALUE),utils.TRUE_VALUE                 ; Always continue

    POP IX

    RET
