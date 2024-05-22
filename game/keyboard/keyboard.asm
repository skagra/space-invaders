;------------------------------------------------------------------------------
;
; Scan the keyboard and return a bit map indicating which of left, right and
; fire was pressed.  
;  
; Usage:
;   CALL get_movement_keys
;   
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

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
    IN A,(C)                                            ; Read the port into the accumulator

    BIT .FIRE_KEY_BIT,A                                 ; Fire key pressed?
    JR NZ,.fire_not_pressed                             ; No so done - and fire flag will be reset

    ; Fire was pressed but was it down last time?
    LD HL,_fire_already_pressed             
    LD A,(HL)
    CP A,0x01
    JR Z,.done

    LD A,E                                              ; Fire pressed so flag in result and not down last time
    OR FIRE_KEY_DOWN_MASK
    LD E,A

    LD HL,_fire_already_pressed  
    LD (HL),0x01                                        ; Flag we read that fire is down

    JR .done

.fire_not_pressed:
    LD HL,_fire_already_pressed  
    LD (HL),0x00                                        ; Flag we read that fire is down

.done:

    IFDEF PAUSEABLE
        LD BC,.PAUSE_PORT                                 
        IN A,(C)                                            

        BIT .PAUSE_KEY_BIT,A                                
        JR NZ,.pauseable_not_pressed                             

        LD HL,_pause_already_pressed             
        LD A,(HL)
        CP A,0x01
        JR Z,.pause_done

        LD A,E                                             
        OR PAUSE_KEY_DOWN_MASK
        LD E,A

        LD HL,_pause_already_pressed  
        LD (HL),0x01                                        

        JR .pause_done

.pauseable_not_pressed:
        LD HL,_pause_already_pressed  
        LD (HL),0x00      

.pause_done

    ENDIF

    LD HL,keys_down
    LD (HL),E      

    POP HL,DE,BC,AF

    RET

.LEFT_RIGHT_PORT:  EQU 0xFDFE
.LEFT_KEY_BIT:     EQU 0   
.RIGHT_KEY_BIT:    EQU 1

.FIRE_PORT:        EQU 0xBFFE
.FIRE_KEY_BIT:     EQU 0

    IFDEF PAUSEABLE
.PAUSE_PORT:     EQU 0x7FFE
.PAUSE_KEY_BIT:  EQU 0
    ENDIF