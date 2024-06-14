draw_insert_coin_section:
    PUSH HL

    LD HL,.TAITO_TEXT
    PUSH HL
    LD HL,.TAITO_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.INSERT_COIN_TITLE
    PUSH HL
    LD HL,.INSERT_COIN_TITLE_COORDS
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.INSERT_COIN_TITLE
    PUSH HL
    LD HL,.INSERT_COIN_TITLE_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL 
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.ONE_OR_TWO_TEXT
    PUSH HL
    LD HL,.ONE_OR_TWO_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.ONE_COIN_TEXT
    PUSH HL
    LD HL,.ONE_COIN_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    LD HL,.TWO_COINS_TEXT
    PUSH HL
    LD HL,.TWO_COINS_COORDS
    PUSH HL
    LD HL,cred_callback
    PUSH HL
    CALL print.slow_print_string
    POP HL
    POP HL
    POP HL
    CALL double_buffer.flush_buffer_to_screen

    POP HL
    
    RET

.TAITO_TEXT:                    BYTE "*TAITO CORPORATION*",0
.TAITO_X:                       EQU 7
.TAITO_Y:                       EQU 21
.TAITO_COORDS:                  EQU (.TAITO_X<<8) + .TAITO_Y

.INSERT_COIN_TITLE:             BYTE "INSERT COIN",0
.INSERT_COIN_TITLE_X:           EQU 12
.INSERT_COIN_TITLE_Y:           EQU 9
.INSERT_COIN_TITLE_COORDS:      EQU (.INSERT_COIN_TITLE_X<<8) + .INSERT_COIN_TITLE_Y

.ONE_OR_TWO_TEXT:               BYTE "<1 OR 2 PLAYERS>",0
.ONE_OR_TWO_X:                  EQU 9
.ONE_OR_TWO_Y:                  EQU 12
.ONE_OR_TWO_COORDS:             EQU (.ONE_OR_TWO_X<<8) + .ONE_OR_TWO_Y

.ONE_COIN_TEXT:                 BYTE "*1 PLAYER 1 COIN",0
.ONE_COIN_X:                    EQU 9
.ONE_COIN_Y:                    EQU 14
.ONE_COIN_COORDS:               EQU (.ONE_COIN_X<<8) + .ONE_COIN_Y

.TWO_COINS_TEXT:                BYTE "*2 PLAYERS 2 COINS",0
.TWO_COINS_X:                   EQU 9
.TWO_COINS_Y:                   EQU 16
.TWO_COINS_COORDS:              EQU (.TWO_COINS_X<<8) + .TWO_COINS_Y
