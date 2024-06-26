print_bcd_nibble:    

.PARAM_NUMBER_LS    EQU 2
.PARAM_COORDS       EQU 0

    PUSH AF,HL,IX

    PARAMS_IX 3                                         ; Get the stack pointer

    ; Get character representing the single digit
    LD A,(IX+.PARAM_NUMBER_LS)                          ; Get the digit
    AND 0x0F                                            ; AND out the top 4 bits
    ADD '0'                                             ; Numeric characters are based at '0'
    
    ; Print the character 
    LD H,0x00
    LD L,A
    PUSH HL

    LD HL,(IX+.PARAM_COORDS)
    PUSH HL

    CALL print_char 

    POP HL
    POP HL
    
    POP IX,HL,AF

    RET

print_bcd_word:    

.PARAM_NUMBER_MS    EQU 3
.PARAM_NUMBER_LS    EQU 2
.PARAM_COORDS       EQU 0

    PUSH AF,BC,HL,IX

    PARAMS_IX 4                                         ; Get the stack pointer

    ; First (most significant) digit
    LD HL,.buffer
    LD A,(IX+.PARAM_NUMBER_MS)                          ; Get the most significant 2 digits
    SRL A                                               ; Shift down the top 4 bits
    SRL A
    SRL A
    SRL A
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A
  
    ; Second digit
    INC HL                                              ; Next position in buffer
    LD A,(IX+.PARAM_NUMBER_MS)                          ; Get the most significant 2 digits
    AND 0x0F                                            ; AND out the top 4 bits
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A

    ; 3rd digit
    INC HL                                              ; Next position in buffer
    LD A,(IX+.PARAM_NUMBER_LS)                          ; Get the least significant 2 digits
    SRL A                                               ; Shift down the top 4 bits
    SRL A
    SRL A
    SRL A
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A

    ; 4th
    INC HL                                              ; Next position in buffer
    LD A,(IX+.PARAM_NUMBER_LS)                          ; Get the most significant 2 digits
    AND 0x0F                                            ; AND out the top 4 bits
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A
    
    LD HL,.buffer
    PUSH HL
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    CALL print_string 
    POP HL
    POP HL
    
    POP IX,HL,BC,AF

    RET

.buffer: BYTE 0x00,0x00,0x00,0x00,0x00

print_bcd_byte:    

.PARAM_NUMBER EQU 2
.PARAM_COORDS EQU 0

    PUSH AF,BC,HL,IX

    PARAMS_IX 4                                         ; Get the stack pointer

    ; First (most significant) digit
    LD HL,.buffer
    LD A,(IX+.PARAM_NUMBER)                             ; Get the most significant 2 digits
    SRL A                                               ; Shift down the top 4 bits
    SRL A
    SRL A
    SRL A
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A
  
    ; Second digit
    INC HL                                              ; Next position in buffer
    LD A,(IX+.PARAM_NUMBER)                             ; Get the most significant 2 digits
    AND 0x0F                                            ; AND out the top 4 bits
    ADD '0'                                             ; Numeric characters are based at '0'
    LD (HL),A
 
    LD HL,.buffer
    PUSH HL
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    CALL print_string 
    POP HL
    POP HL
    
    POP IX,HL,BC,AF

    RET

.buffer: BYTE 0x00,0x00,0x00