;------------------------------------------------------------------------------
; Add the a value to the player 1 score
; 
; Usage:
;   PUSH rr             ; Value to add to the score
;   CALL add_to_score
;   POP rr
;------------------------------------------------------------------------------

add_to_score:

.PARAM_INCREMENT EQU 0

    PUSH AF,IX

    PARAMS_IX 2                                         ; Point IX to the first stack parameter

    LD HL,(IX+.PARAM_INCREMENT)                         ; Grab the value to add to the score
    OR A                                                ; Ensure the half carry is reset

    LD A,(score_lsb_player_1)                           ; Get the current score low byte
    ADD L                                               ; Add the increment low byte
    DAA                                                 ; Adjust for BCD
    LD (score_lsb_player_1),A                           ; Store the new low byte of the score

    LD A,(score_msb_player_1)                           ; Grab the current score high byte
    ADC H                                               ; Add the increment high byte with any carry  
    DAA                                                 ; Adjust for BCD
    LD (score_msb_player_1),A                           ; Store the new high byte of the score

    POP IX,AF

    RET

