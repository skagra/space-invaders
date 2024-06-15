;------------------------------------------------------------------------------
; Add a credit
; 
; Usage:
;   CALL event_credit_added
;------------------------------------------------------------------------------

event_credit_added:
    PUSH AF
    
    LD A,(credits)
    CP .MAX_CREDITS
    JR Z,.done
    OR A                                                ; Ensure the half carry is reset
    INC A
    DAA                                                 ; BCD correction
    LD (credits),A
    
.done:
    POP AF

    RET
    
.MAX_CREDITS: EQU 0x99

;------------------------------------------------------------------------------
; Spend a credit
; 
; Usage:
;   CALL event_credit_used
;------------------------------------------------------------------------------

event_credit_used:
    PUSH AF
    
    LD A,(credits)
    CP 0x00
    JR Z,.done
    OR A                                                ; Ensure the half carry is reset
    DEC A
    DAA                                                 ; BCD correction
    LD (credits),A
    
.done:
    POP AF
    
    RET
