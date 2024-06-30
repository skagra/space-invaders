;------------------------------------------------------------------------------
; Initialize the module
; 
; Usage:
;   CALL init
;------------------------------------------------------------------------------
init:
    RET

;------------------------------------------------------------------------------
; Initialize a new sheet
; 
; Usage:
;   CALL new_sheet
;------------------------------------------------------------------------------
new_sheet:
    PUSH AF,HL

    ; No active saucer
    LD A,_STATE_NO_SAUCER_VALUE
    LD (_saucer_state),A

    ; Disable both the launch of saucer and launch timer
    LD A,utils.FALSE_VALUE
    LD (enabled),A
    LD (timer_enabled),A

    ; Initialize the launch timer
    LD HL,0x0000
    LD (_saucer_timer),HL

    POP HL,AF
    
    RET