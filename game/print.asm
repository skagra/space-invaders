    MODULE print

;------------------------------------------------------------------------------
;
; Print a null terminated string of characters
; 
; Usage:
;   PUSH rr  ; Pointer to the null terminated string
;   PUSH rr  ; Character cell coordiates (X in high byte, Y in low byte)
;   CALL print_string
;   POP rr   ; Ditch the supplied parameters
;   POP rr    
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

PS_PARAM_STRING:    EQU 14
PS_PARAM_COORDS:    EQU 12

print_string:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD DE,(IX+PS_PARAM_STRING)          ; Pointer to current character
    LD BC,(IX+PS_PARAM_COORDS)          ; Current coords X in B, Y in C

.ps_char_loop:
    ; Get character to print
    LD A,(DE)                           ; Have we hit the end of the string?
    CP 0x00
    JR Z,.ps_done

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

    JR .ps_char_loop                    ; Next character

.ps_done:
    POP IX,HL,DE,BC,AF

    RET

;------------------------------------------------------------------------------
;
; Print a single character
; 
; Usage:
;   PUSH rr  ; Character to print in LSB
;   PUSH rr  ; Character cell coordiates (X in high byte, Y in low byte)
;   CALL print_char
;   POP rr   ; Ditch the supplied parameters
;   POP rr    
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

PC_PARAM_CHAR:      EQU 14
PC_PARAM_COORDS:    EQU 12

print_char:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    ; Calculate memory location from coords
    LD HL,(IX+PC_PARAM_COORDS)
    PUSH HL
    PUSH HL                             ; Space for return value
    CALL char_coords_to_mem
    POP HL                              ; Grab return value
    LD (.pc_print_mem_ptr),HL           ; Store the result
    POP HL                              ; Ditch the supplied parameter

    ; Find the bitmap for the required character
    LD HL,mmap.ROM_CHARACTER_SET-0x100  ; Then the char data is at character code * 8 offset
    LD DE,(IX+PC_PARAM_CHAR)            ; Get the char to draw
    SLA E                               ; Multiply char code by 8
    RL D
    SLA E
    RL D
    SLA E
    RL D
    ADD HL,DE                           ; HL now points at character bitmap
    LD (.pc_char_data_ptr), HL          ; Store pointer to first byte of character data 

    LD B,0x08                           ; Loop counter for drawing bytes of character data

.pc_y_loop:
    LD HL,(.pc_char_data_ptr)           ; Get character bits to print
    LD A,(HL)
    
    INC HL                              ; Move character data pointer to next byte
    LD (.pc_char_data_ptr),HL

    LD HL,(.pc_print_mem_ptr)           ; Write character bits into screen memory
    LD (HL), A

    LD DE,0x0100                        ; Move pointer to screen memory down a line
    ADD HL,DE
    LD (.pc_print_mem_ptr),HL

    DEC B                               ; Done?
    JR NZ,.pc_y_loop 

    POP IX,HL,DE,BC,AF

    RET

.pc_print_mem_ptr:  BLOCK 2
.pc_char_data_ptr:  BLOCK 2

;------------------------------------------------------------------------------
;
; Translate x,y in character cells to screen memory address
;
; The structure of the screen memory address is formed as follows:
;
;   15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
;   0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X4 X3 X2 X1 X0
; 
; Usage:
;   PUSH rr  ; X high byte, Y low byte
;   PUSH rr  ; Make space for return value
;   CALL char_coords_to_mem
;   POP rr   ; Grab the result
;   POP rr   ; Ditch the supplied parameter
;
; Return values:
;   Address of character cell on top of stack
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

CCTM_PARAM_COORDS:   EQU 12             ; Coordinates

CCTM_RTN_ADDR:       EQU 10             ; Return address
char_coords_to_mem:
    PUSH AF,BC,HL,IX
   
    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    ; Y row
    LD BC, (IX+CCTM_PARAM_COORDS)       ; Get coords from the stack
    LD B, 0x00                          ; B=0x00, C=Y coord
    SLA C                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, .cctm_y_lookup_table         ; Base of lookup table in HL
    ADD HL,BC                           ; Location of the row start in the lookup table
    LD BC,(HL)                          ; Location of row start
    LD HL,BC                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+CCTM_PARAM_COORDS)       ; Get coords from the stack
    LD A,B                              ; Grab the x coord
    OR L                                ; OR it into memory address
    LD L,A                              ; Store in L
  
    LD (IX+CCTM_RTN_ADDR),HL            ; Set the return value on the stack
    
    POP IX,BC,HL,AF

    RET

.cctm_y_lookup_table:
	WORD 0x4000, 0x4020, 0x4040, 0x4060, 0x4080, 0x40A0,  0x40C0,  0x40E0
	WORD 0x4800, 0x4820, 0x4840, 0x4860, 0x4880, 0x48A0,  0x48C0,  0x48E0
	WORD 0x5000, 0x5020, 0x5040, 0x5060, 0x5080, 0x50A0,  0x50C0,  0x50E0

    ENDMODULE

