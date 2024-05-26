add_to_score:

.PARAM_INCREMENT EQU 6

    PUSH AF,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

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

event_alien_hit_by_player_missile:

.PARAM_ALIEN_TYPE EQU 10

    PUSH AF,BC,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,ALIEN_SCORE_VALUES                            ; Alien score lookup table
    LD B,0x00                                               
    LD C,(IX+.PARAM_ALIEN_TYPE)                         ; Alien type gives index into table
    ADD HL,BC                                           ; Add the index to the base
    LD C,(HL)                                           ; Grab the alien score value
    
    PUSH BC                                             ; Add the alien score value to the current score
    CALL add_to_score
    POP BC

    POP IX,HL,BC,AF

    RET


; Alien scores index by the alien type
ALIEN_SCORE_VALUES: BYTE 0x10,0x20,0x30
