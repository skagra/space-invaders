    MACRO DEBOUNCE keyboard_test_bit, pressed_last_time, result_value
        ; Key pressed?
        BIT keyboard_test_bit,B  
        ; No so done - and fire flag will be reset                              
        JR NZ,.not_pressed                                 

        ; Pressed - but was it pressed last time?         
        LD A,(pressed_last_time)
        BIT utils.TRUE_BIT,A
        JR NZ,.done

        ; Fire pressed and not pressed last time so flag in result
        LD A,E                                              
        OR result_value
        LD E,A

        ; Flag we read that the key is down 
        LD HL,pressed_last_time
        LD (HL),utils.TRUE_VALUE                                        

        JR .done

.not_pressed:
        ; Key not down so reset record 
        LD HL,pressed_last_time
        LD (HL),utils.FALSE_VALUE

.done
    ENDM

get_keys:
    PUSH AF,BC,DE,HL

    LD E,0x00                                           ; Initialize result

    ; Left and right keys
    LD BC,.LEFT_RIGHT_PORT                              ; Left/Right port
    IN A,(C)                                            ; Read the port into the accumulator
    LD D,A                                              ; Store it for later

    ; Left key
    BIT .LEFT_KEY_BIT,D
    JR Z,.left_pressed

    ; Right key
    BIT .RIGHT_KEY_BIT,D                                ; Right pressed?
    JR Z,.right_pressed

    JR .fire

.left_pressed:       
    LD A,E                                              ; Left pressed so flag in result
    OR LEFT_KEY_DOWN_MASK
    LD E,A

    JR .fire

.right_pressed:
    LD A,E                                              ; Right key pressed so flag in result
    OR RIGHT_KEY_DOWN_MASK
    LD E,A

    JR .fire

.fire:
    ; Fire key
    LD BC,.FIRE_PORT                                    ; Fire port
    IN B,(C)                                            ; Read the port into the accumulator

    DEBOUNCE .FIRE_KEY_BIT, _fire_already_pressed, FIRE_KEY_DOWN_MASK
    ; Fall through

.credits_and_play:
    LD BC,.CREDS_PLAY_PORT                                   
    IN B,(C)  

    DEBOUNCE .P1_KEY_BIT, _p1_already_pressed, P1_KEY_DOWN_MASK
    DEBOUNCE .P2_KEY_BIT, _p2_already_pressed, P2_KEY_DOWN_MASK
    DEBOUNCE .CRED_KEY_BIT, _creds_already_pressed, CREDS_KEY_DOWN_MASK

    ; Fall through
    LD BC,.PAUSE_PORT                                 
    IN B,(C)                                            

    DEBOUNCE .PAUSE_KEY_BIT, _pause_already_pressed, PAUSE_KEY_DOWN_MASK
 
    ; Record result
    LD HL,keys_down
    LD (HL),E      

    POP HL,DE,BC,AF

    ; LOGPOINT [KEYBOARD] Keys down=${(keyboard.keys_down):hex}

    RET

.LEFT_RIGHT_PORT:   EQU 0xFDFE
.LEFT_KEY_BIT:      EQU 0               ; A key
.RIGHT_KEY_BIT:     EQU 1               ; S key

.FIRE_PORT:         EQU 0xBFFE
.FIRE_KEY_BIT:      EQU 0               ; Enter key

.CREDS_PLAY_PORT:   EQU 0xF7FE
.P1_KEY_BIT:        EQU 0               ; 1 key
.P2_KEY_BIT:        EQU 1               ; 2 key
.CRED_KEY_BIT:      EQU 4               ; 5 key

.PAUSE_PORT:        EQU 0x7FFE        
.PAUSE_KEY_BIT:     EQU 0               ; Space bar
 