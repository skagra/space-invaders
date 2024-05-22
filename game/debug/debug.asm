_vtrace_flash:
    PUSH AF,HL

    LD A,(_vtrace_count)
    DEC A
    LD (_vtrace_count),A
    JR NZ,.done

    LD A,_VTRACE_INTERVAL
    LD (_vtrace_count),A

    LD HL,_VTRACE_BYTE
    LD A,(HL)
    XOR draw_common.CA_BG_WHITE
    LD (HL),A

.done:
    POP AF,HL

    RET

    MACRO DEBUG_VTRACE_FLASH
        IFDEF DEBUG
            CALL debug._vtrace_flash
        ENDIF
    ENDM 

_cycle_flash:
    PUSH AF,HL

    LD HL,_CYCLE_BYTE
    LD A,(HL)
    XOR draw_common.CA_BG_MAGENTA
    LD (HL),A

    POP AF,HL

    RET

    MACRO DEBUG_CYCLE_FLASH
        IFDEF DEBUG
            CALL debug._cycle_flash
        ENDIF
    ENDM 

_flag_error:

._PARAM_CHAR: EQU 8

    PUSH AF,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Set colour attribute
    LD HL,_FLAG_ERROR_BYTE                              
    LD (HL),draw_common.CA_BG_RED|draw_common.CA_FG_WHITE

    ; Draw the error indicator character
    LD HL,(IX+._PARAM_CHAR)
    PUSH HL
    LD HL,0x0217
    PUSH HL
    CALL print.print_char
    POP AF
    POP HL

    POP IX,HL,AF

.forever:   
    JR .forever
    
    RET

_FLAG_ERROR_BYTE:       EQU _CYCLE_BYTE+1

    MACRO DB_FLAG_ERROR code
        IFDEF DEBUG
            PUSH HL
            LD HL,code
            PUSH HL
            CALL debug._flag_error
            POP HL
            POP HL
        ENDIF
    ENDM 









   