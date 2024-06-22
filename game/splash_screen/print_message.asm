print_message:

.PARAM_COUNT:   EQU 2
.PARAM_MESSAGE: EQU 0

    PUSH BC,DE,HL,IX

    PARAMS_IX 4                                         ; Get the stack pointer

    LD B,(IX+.PARAM_COUNT)                              ; Loop counter
    LD HL,(IX+.PARAM_MESSAGE)        

    LD A,utils.FALSE_VALUE
    LD (_next_screen),A

.text_loop:
    LD DE,(HL)                                          ; Current line
    LD IX,HL

    LD DE,(IX+.MESSAGE_TEXT_OFFSET)                     ; Text
    PUSH DE
    LD DE,(IX+.MESSAGE_COORDS_OFFSET)                   ; Coords
    PUSH DE
    LD DE,next_screen_callback                          ; Exit on space pressed
    PUSH DE
    CALL print.slow_print_string                        ; Slow print current line
    POP DE
    POP DE 
    POP DE

    INC HL
    INC HL
    INC HL
    INC HL

    DJNZ .text_loop

    POP IX,HL,DE,BC

    RET

.MESSAGE_COORDS_OFFSET:     EQU 0
.MESSAGE_TEXT_OFFSET:       EQU 2

next_screen_callback:

.RTN_VALUE: EQU 0

    PUSH AF,IX

    PARAMS_IX 2                                         ; Get the stack pointer

    LD (IX+.RTN_VALUE),utils.TRUE_VALUE                 ; Always continue

    LD A,(_next_screen)
    BIT utils.TRUE_BIT,A
    JR Z,.done

    LD (IX+.RTN_VALUE),utils.FALSE_VALUE

.done
    POP IX,AF

    RET