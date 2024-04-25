    MODULE keyboard

LEFT_KEY_DOWN:  EQU 0b00000001
RIGHT_KEY_DOWN: EQU 0b00000010
FIRE_KEY_DOWN:  EQU 0b00000100

LR_PORT:        EQU 0xFDFE
LEFT_KEY_MASK:  EQU 0x00000001
RIGHT_KEY_MASK: EQU 0x00000010
FIRE_PORT:      EQU 0xBFFE

FIRE_KEY_MASK:  EQU 0x00000001
get_movement_keys:
    PUSH BC,AF
    LD L,0x00                   ; Initialize result

    ; Left and right keys
    LD BC,LR_PORT               ; Left/Right port
    IN A,(C)                    ; Read the port into the accumulator
    LD H,A                      ; Store it for later

    AND LEFT_KEY_MASK           ; Left key pressed?
    JR Z,left_not_pressed       
    LD A,L                      ; Left pressed so flag in result
    OR LEFT_KEY_DOWN
    LD L,A
    
left_not_pressed:
    LD A,H                      ; Restore saved key press
    AND RIGHT_KEY_MASK          ; Right pressed?
    JR Z,right_not_pressed
    LD A,L                      ; Right key pressed so flag in result
    OR RIGHT_KEY_DOWN
    LD L,A

right_not_pressed:

    ; Fire key
    LD BC,FIRE_PORT             ; Fire port
    IN A,(C)                    ; Read the port into the accumulator

    AND FIRE_KEY_MASK           ; Fire key pressed?
    JR Z,fire_not_pressed       
    LD A,L                      ; Fire pressed so flag in result
    OR FIRE_KEY_DOWN
    LD L,A

fire_not_pressed:

    LD H,0x00
    POP AF,BC

    RET

    ENDMODULE