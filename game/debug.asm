    MODULE debug

init:
    PUSH AF

    IFDEF DEBUG
        LD A,_VTRACE_INTERVAL
        LD (_vtrace_count),A
        LD A,0x00
        LD (_VTRACE_BYTE),A 
        LD (_CYCLE_BYTE),A
    ENDIF

    POP AF

    RET

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
    XOR draw.CA_BG_WHITE
    LD (HL),A

.done:
    POP AF,HL

    RET

_vtrace_count:      BLOCK 1
_VTRACE_BYTE:       EQU mmap.SCREEN_ATTR_START+(draw.SCREEN_HEIGHT_CHARS-1)*draw.SCREEN_WIDTH_CHARS
_VTRACE_INTERVAL:   EQU 5

    MACRO DEBUG_VTRACE_FLASH
        IFDEF DEBUG
            CALL debug._vtrace_flash
        ENDIF
    ENDM 

_cycle_flash:
    PUSH AF,HL

    LD HL,_CYCLE_BYTE
    LD A,(HL)
    XOR draw.CA_BG_MAGENTA
    LD (HL),A

    POP AF,HL

    RET

_CYCLE_BYTE:       EQU _VTRACE_BYTE+1

    MACRO DEBUG_CYCLE_FLASH
        IFDEF DEBUG
            CALL debug._cycle_flash
        ENDIF
    ENDM 

_flag_error:

._PARAM_CHAR:      EQU 8

    PUSH AF,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Set colour attribute
    LD HL,_FLAG_ERROR_BYTE                              
    LD (HL),draw.CA_BG_RED|draw.CA_FG_WHITE

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

_FLAG_ERROR_BYTE:       EQU _VTRACE_BYTE+2

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

_total_memory_usage: DEFL 0

    MACRO MEMORY_USAGE name, label 
		DISPLAY "MEM_USAGE: ",name," - start: ",label, ", end: ", $, ", size: ",/H,$-label,/D," (",$-label," bytes)"
debug._total_memory_usage=debug._total_memory_usage+$-label
	ENDM

    MACRO TOTAL_MEMORY_USAGE
        DISPLAY "TOTAL_MEM_USAGE: ",debug._total_memory_usage," (",/D,debug._total_memory_usage," bytes)"
    ENDM

    ENDMODULE





   