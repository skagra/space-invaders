score: 
score_lsb: BYTE 1
score_msb: BYTE 1

init:
    LD HL,score
    LD DE,0x0000
    LD (HL),DE

    RET

add_to_score:

.PARAM_INCREMENT EQU 6

    PUSH AF,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_INCREMENT)                         ; Grab the value to add to the score
    OR A                                                ; Ensure the half carry is reset

    LD A,(score_lsb)                                    ; Get the current score low byte
    ADD L                                               ; Add the increment low byte
    DAA                                                 ; Adjust for BCD
    LD (score_lsb),A                                    ; Store the new low byte of the score

    LD A,(score_msb)                                    ; Grab the current score high byte
    ADC H                                               ; Add the increment high byte with any carry  
    DAA                                                 ; Adjust for BCD
    LD (score_msb),A                                    ; Store the new high byte of the score

    POP IX,AF

    RET

add_alien_value_to_score:

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

; TODO - These alien types should live elsewhere, but don't want dependency on alien_pack
ALIEN_TYPE_0:       EQU 0
ALIEN_TYPE_1:       EQU 1
ALIEN_TYPE_2:       EQU 2

ALIEN_SCORE_VALUES: BYTE 0x10,0x20,0x30
