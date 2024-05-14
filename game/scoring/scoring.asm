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

    LD HL,(IX+.PARAM_INCREMENT)

    ; LOGPOINT [SCORING] Increment=${HL}, score_lsb=${(scoring.score_lsb):hex}, score_msb=${(scoring.score_msb):hex}

    OR A
    LD A,(score_lsb)
    ADD L
    ; LOGPOINT [SCORING] Pre DAA A=${A:hex}
    DAA
    ; LOGPOINT [SCORING] Post DAA A=${A:hex}
    LD (score_lsb),A

    ; LOGPOINT [SCORING] Added LSB score_lsb=${(scoring.score_lsb):hex}, score_msb=${(scoring.score_msb):hex}

    LD A,(score_msb)
    ADC H
    DAA
    LD (score_msb),A

    ; LOGPOINT [SCORING] Added MSB score_lsb=${(scoring.score_lsb):hex}, score_msb=${(scoring.score_msb):hex}

    POP IX,AF

    RET

add_alien_value_to_score:

.PARAM_ALIEN_TYPE EQU 10

    PUSH AF,BC,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,ALIEN_VALUES                                  ; Alien score lookup table
    LD B,0x00                                               
    LD C,(IX+.PARAM_ALIEN_TYPE)                         ; Alien type gives index into table
    ADD HL,BC                                           ; Index to base
    LD C,(HL)                                           ; Grab the alien value
    
    PUSH BC                                             ; Add the alien value to the current score
    CALL add_to_score
    POP BC

    POP IX,HL,BC,AF

    RET

ALIEN_TYPE_0: EQU 0
ALIEN_TYPE_1: EQU 1
ALIEN_TYPE_2: EQU 2

ALIEN_VALUES:   BYTE 0x10,0x20,0x30

SCORE_CHAR_X: EQU 5
SCORE_CHAR_Y: EQU 1

SCORE_CHAR_COORDS:  EQU (SCORE_CHAR_X<<8) + SCORE_CHAR_Y

print_score:
    PUSH HL

    LD HL,(score)
    PUSH HL
    LD HL,SCORE_CHAR_COORDS
    PUSH HL
    CALL print.print_bcd_word
    POP HL
    POP HL
    
    POP HL

    RET