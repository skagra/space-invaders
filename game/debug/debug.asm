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
    XOR colours.CA_BG_WHITE
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
    XOR colours.CA_BG_MAGENTA
    LD (HL),A

    POP AF,HL

    RET

    MACRO DEBUG_CYCLE_FLASH
        IFDEF DEBUG
            CALL debug._cycle_flash
        ENDIF
    ENDM 

_flag_error:

.PARAM_CHAR: EQU 0

    PUSH AF,HL,IX

    PARAMS_IX 3                                         ; Get the stack pointer

    ; Set colour attribute
    LD HL,_FLAG_ERROR_BYTE                              
    LD (HL),colours.CA_BG_RED|colours.CA_FG_WHITE

    ; Draw the error indicator character
    LD H,(IX+.PARAM_CHAR+1)
    LD L,(IX+.PARAM_CHAR)

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
            CALL _flag_error
            POP HL
            POP HL
        ENDIF
    ENDM 









   