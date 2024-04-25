    MODULE print

PS_PARAM_STRING:    EQU 14
PS_PARAM_COORDS:    EQU 12

print_string:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD DE,(IX+PS_PARAM_STRING)          ; Pointer to current character
    LD BC,(IX+PS_PARAM_COORDS)          ; Current coords X in B, Y in C

ps_char_loop:
    ; Get character to print
    LD A,(DE)                           ; Have we hit the end of the string?
    CP 0x00
    JR Z,ps_done

    LD H, 0x00  
    LD L,A
    PUSH HL                             ; Character to print
    PUSH BC                             ; Character cell coordinates
    
    call print_char                     ; Print character

    POP HL                              ; Ditch parameters
    POP HL

    INC DE                              ; Next character
    LD HL,0x0100                        ; Inc X coord
    ADD HL,BC
    LD BC,HL

    JR ps_char_loop                     ; Next character

ps_done:
    POP IX,HL,DE,BC,AF

    RET

PC_PARAM_CHAR:      EQU 14
PC_PARAM_COORDS:    EQU 12

print_char:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+PC_PARAM_COORDS)
    PUSH HL
    CALL char_coords_to_mem
    LD (print_mem_ptr),HL
    POP HL

    LD HL,mmap.ROM_CHARACTER_SET-0x100  ; Then the char data is at character code * 8 offset
    LD DE,(IX+PC_PARAM_CHAR)            ; Get the char to draw
    SLA E                               ; Multiply by 8
    RL D
    SLA E
    RL D
    SLA E
    RL D
    ADD HL,DE
    LD (char_data_ptr), HL              ; Store pointer to first byte of character data 

    LD B,0x08

y_loop:
    LD HL,(char_data_ptr)               ; Get character bits to print
    LD A,(HL)

    LD HL,(print_mem_ptr)               ; Write character bits into screen memory
    LD (HL), A

    LD DE,0x0100                        ; Move pointer to screen memory down a line
    ADD HL,DE
    LD (print_mem_ptr),HL

    LD HL,(char_data_ptr)               ; Move to next byte of chacter data
    INC HL
    LD (char_data_ptr),HL

    DEC B                               ; Done?
    JR NZ,y_loop 

    POP IX,HL,DE,BC,AF

    RET

print_mem_ptr:  BLOCK 2
char_data_ptr:  BLOCK 2


;------------------------------------------------------------------------------
; Translate x,y in character cells to screen memory address
;
; The structure of the screen memory address is formed as follows:
;
;   15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
;   0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X4 X3 X2 X1 X0
; ;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;
; Return values:
;   HL - Screen address
;
; Registers modified:
;   HL
;------------------------------------------------------------------------------

CCTM_PARAM_COORDS:   EQU 8               ; Coordinates

char_coords_to_mem:
    PUSH AF,BC,IX
   
    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    ; Y row
    LD BC, (IX+CCTM_PARAM_COORDS)       ; Get coords from the stack
    LD B, 0x00                          ; B=0x00, C=Y coord
    SLA C                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, y_lookup_table               ; Base of lookup table in HL
    ADD HL,BC                           ; Location of the row start in the lookup table
    LD BC,(HL)                          ; Location of row start
    LD HL,BC                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+CCTM_PARAM_COORDS)        ; Get coords from the stack
    LD A,B                              ; Grab the x coord
    OR L                                ; OR it into memory address
    LD L,A                              ; Store in L
  
    POP IX,BC,AF

    RET

y_lookup_table:
	WORD 0x4000, 0x4020, 0x4040, 0x4060, 0x4080, 0x40A0,  0x40C0,  0x40E0
	WORD 0x4800, 0x4820, 0x4840, 0x4860, 0x4880, 0x48A0,  0x48C0,  0x48E0
	WORD 0x5000, 0x5020, 0x5040, 0x5060, 0x5080, 0x50A0,  0x50C0,  0x50E0

    ENDMODULE

