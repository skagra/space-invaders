;------------------------------------------------------------------------------
; Initialise the module
; 
; Usage:
;   CALL init
;------------------------------------------------------------------------------

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