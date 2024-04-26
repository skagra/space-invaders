    MODULE keyboard

;------------------------------------------------------------------------------
;
; Scan the keyboard and return a bit map indicating which of left, right and
; fire was pressed.  The result is returned on the top of the stack.
;  
; Usage:
;   PUSH rr                 ; Make space for the return value
;   CALL get_movement_keys
;   LD A,(SP)               ; Grab the result
;   POP rr                  ; Ditch the result stack space
;   
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

LEFT_KEY_DOWN:  EQU 0b00000001
RIGHT_KEY_DOWN: EQU 0b00000010
FIRE_KEY_DOWN:  EQU 0b00000100

LR_PORT:        EQU 0xFDFE
LEFT_KEY_BIT:   EQU 0   
RIGHT_KEY_BIT:  EQU 1

FIRE_PORT:      EQU 0xBFFE
FIRE_KEY_BIT:   EQU 0

GMK_RTN_KEYS:   EQU 12

get_movement_keys:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                    ; Get the stack pointer
    ADD IX,SP

    LD E,0x00                   ; Initialize result

    ; Left and right keys
    LD BC,LR_PORT               ; Left/Right port
    IN A,(C)                    ; Read the port into the accumulator
    LD D,A                      ; Store it for later

    ; Left key
    BIT LEFT_KEY_BIT,D
    JR NZ,.left_not_pressed       
    LD A,E                      ; Left pressed so flag in result
    OR LEFT_KEY_DOWN
    LD E,A
    
.left_not_pressed:
    ; Right key
    BIT RIGHT_KEY_BIT,D         ; Right pressed?
    JR NZ,.right_not_pressed
    LD A,E                      ; Right key pressed so flag in result
    OR RIGHT_KEY_DOWN
    LD E,A

.right_not_pressed:
    ; Fire key
    LD BC,FIRE_PORT             ; Fire port
    IN A,(C)                    ; Read the port into the accumulator

    BIT FIRE_KEY_BIT,A          ; Fire key pressed?
    JR NZ,.fire_not_pressed       
    LD A,E                      ; Fire pressed so flag in result
    OR FIRE_KEY_DOWN
    LD E,A

.fire_not_pressed:
    LD D,0x00                   ; Return the result on the stack
    LD (IX+GMK_RTN_KEYS),E      

    POP IX,HL,DE,BC,AF

    RET

    ENDMODULE