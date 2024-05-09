    MODULE keyboard

_module_start:

LEFT_KEY_DOWN_MASK:     EQU 0b00000001
RIGHT_KEY_DOWN_MASK:    EQU 0b00000010
FIRE_KEY_DOWN_MASK:     EQU 0b00000100

LEFT_KEY_DOWN_BIT:      EQU 0
RIGHT_KEY_DOWN_BIT:     EQU 1
FIRE_KEY_DOWN_BIT:      EQU 2

keys_down:              BLOCK 1

_fire_already_pressed:  BLOCK 1

;------------------------------------------------------------------------------
;
; Initialise the module
;
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------
init:
    PUSH HL

    LD HL,_fire_already_pressed
    LD (HL),0x00

    POP HL

    RET
    
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

get_movement_keys:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                    ; Get the stack pointer
    ADD IX,SP

    LD E,0x00                   ; Initialize result

    ; Left and right keys
    LD BC,._LEFT_RIGHT_PORT     ; Left/Right port
    IN A,(C)                    ; Read the port into the accumulator
    LD D,A                      ; Store it for later

    ; Left key
    BIT ._LEFT_KEY_BIT,D
    JR Z,.left_pressed

    ; Right key
    BIT ._RIGHT_KEY_BIT,D       ; Right pressed?
    JR Z,.right_pressed

    JR .fire

.left_pressed:       
    LD A,E                      ; Left pressed so flag in result
    OR LEFT_KEY_DOWN_MASK
    LD E,A

    JR .fire

.right_pressed:
    LD A,E                      ; Right key pressed so flag in result
    OR RIGHT_KEY_DOWN_MASK
    LD E,A

    JR .fire

.fire:
    ; Fire key
    LD BC,._FIRE_PORT           ; Fire port
    IN A,(C)                    ; Read the port into the accumulator

    BIT ._FIRE_KEY_BIT,A        ; Fire key pressed?
    JR NZ,.fire_not_pressed     ; No so done - and fire flag will be reset

    ; Fire was pressed but was it down last time?
    LD HL,_fire_already_pressed             
    LD A,(HL)
    CP A,0x01
    JR Z,.done

    LD A,E                      ; Fire pressed so flag in result and not down last time
    OR FIRE_KEY_DOWN_MASK
    LD E,A

    LD HL,_fire_already_pressed  
    LD (HL),0x01               ; Flag we read that fire is down

    JR .done

.fire_not_pressed:
    LD HL,_fire_already_pressed  
    LD (HL),0x00               ; Flag we read that fire is down

.done:

    LD HL,keys_down
    LD (HL),E      

    POP IX,HL,DE,BC,AF

    RET

._LEFT_RIGHT_PORT:  EQU 0xFDFE
._LEFT_KEY_BIT:     EQU 0   
._RIGHT_KEY_BIT:    EQU 1

._FIRE_PORT:        EQU 0xBFFE
._FIRE_KEY_BIT:     EQU 0

    MEMORY_USAGE "keyboard        ",_module_start
    
    ENDMODULE