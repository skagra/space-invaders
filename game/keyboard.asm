    MODULE keyboard

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
    RET
    
;------------------------------------------------------------------------------
;
; Scan the keyboard and return a bit map indicating which of left, right and
; fire was pressed.  The result is returned on the top of the stack.
;  
; Usage:
;   PUSH rr                 ; Make space for the return value
;   CALL get_movement_keys
;   POP rr                  ; Grab the result is LSB
;   
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

LEFT_KEY_DOWN_MASK:  EQU 0b00000001
RIGHT_KEY_DOWN_MASK: EQU 0b00000010
FIRE_KEY_DOWN_MASK:  EQU 0b00000100

LEFT_KEY_DOWN_BIT:  EQU 0
RIGHT_KEY_DOWN_BIT: EQU 1
FIRE_KEY_DOWN_BIT:  EQU 2

get_movement_keys:

._RTN_KEYS:         EQU 12

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
    JR NZ,.left_not_pressed       
    LD A,E                      ; Left pressed so flag in result
    OR LEFT_KEY_DOWN_MASK
    LD E,A
    
.left_not_pressed:
    ; Right key
    BIT ._RIGHT_KEY_BIT,D       ; Right pressed?
    JR NZ,.right_not_pressed
    LD A,E                      ; Right key pressed so flag in result
    OR RIGHT_KEY_DOWN_MASK
    LD E,A

.right_not_pressed:
    ; Fire key
    LD BC,._FIRE_PORT           ; Fire port
    IN A,(C)                    ; Read the port into the accumulator

    BIT ._FIRE_KEY_BIT,A        ; Fire key pressed?
    JR NZ,.fire_not_pressed       
    LD A,E                      ; Fire pressed so flag in result
    OR FIRE_KEY_DOWN_MASK
    LD E,A

.fire_not_pressed:
    LD D,0x00                   ; Return the result on the stack
    LD (IX+._RTN_KEYS),E      

    POP IX,HL,DE,BC,AF

    RET

._LEFT_RIGHT_PORT:  EQU 0xFDFE
._LEFT_KEY_BIT:     EQU 0   
._RIGHT_KEY_BIT:    EQU 1

._FIRE_PORT:        EQU 0xBFFE
._FIRE_KEY_BIT:     EQU 0

    ENDMODULE