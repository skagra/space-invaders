    MODULE print

_print_start:

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

print_string:
    
._PARAM_STRING_PTR:    EQU 14
._PARAM_COORDS:    EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD DE,(IX+._PARAM_STRING_PTR)                       ; Pointer to current character
    LD BC,(IX+._PARAM_COORDS)                           ; Current coords X in B, Y in C

.ps_char_loop:
    ; Get character to print
    LD A,(DE)                                           ; Have we hit the end of the string?
    CP 0x00
    JR Z,.ps_done

    LD H, 0x00  
    LD L,A
    PUSH HL                                             ; Character to print
    PUSH BC                                             ; Character cell coordinates
    
    call print_char                                     ; Print character

    POP HL                                              ; Ditch parameters
    POP HL

    INC DE                                              ; Next character
    LD HL,0x0100                                        ; Inc X coord
    ADD HL,BC
    LD BC,HL

    JR .ps_char_loop                                    ; Next character

.ps_done:

    CALL draw.copy_buffer_to_screen

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

print_char:

._PARAM_CHAR:      EQU 14
._PARAM_COORDS:    EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Calculate memory location from coords
    LD HL,(IX+._PARAM_COORDS)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL char_coords_to_mem
    POP HL                                              ; Grab return value
    LD (._print_mem_ptr),HL                             ; Store the result
    POP HL                                              ; Ditch the supplied parameter

    ; Find the bitmap for the required character
    LD HL,character_set.CHARACTER_SET_BASE-(32*8)       ; Then the char data is at character code * 8 offset
    LD DE,(IX+._PARAM_CHAR)                             ; Get the char to draw
    SLA E                                               ; Multiply char code by 8
    RL D
    SLA E
    RL D
    SLA E
    RL D
    ADD HL,DE                                           ; HL now points at character bitmap
    LD (._char_data_ptr), HL                            ; Store pointer to first byte of character data 

    LD B,0x08                                           ; Loop counter for drawing bytes of character data

.pc_y_loop:
    LD HL,(._char_data_ptr)                             ; Get character bits to print
    LD A,(HL)
    
    INC HL                                              ; Move character data pointer to next byte
    LD (._char_data_ptr),HL

    LD HL,(._print_mem_ptr)                             ; Write character bits into screen memory
    LD (HL), A

    ; Record that we are writing to the double buffer
    LD HL,(draw._buffer_stack_top)                      ; Top of stack address
    LD DE,(._print_mem_ptr)       
    LD (HL),DE                                          ; Write screen buffer address at top of stack            
    INC HL                                              ; Increase the stack top pointer +2 as a word was written
    INC HL
    LD (draw._buffer_stack_top),HL

    LD HL,(._print_mem_ptr)
    LD DE,0x0100                                        ; Move pointer to screen memory down a line
    ADD HL,DE
    LD (._print_mem_ptr),HL

    DEC B                                               ; Done?
    JR NZ,.pc_y_loop 

    POP IX,HL,DE,BC,AF

    RET

._print_mem_ptr:  BLOCK 2
._char_data_ptr:  BLOCK 2

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

char_coords_to_mem:

._PARAM_COORDS:   EQU 12                                ; Coordinates
._RTN_ADDR:       EQU 10                                ; Return address

    PUSH AF,BC,HL,IX
   
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Y row
    LD BC, (IX+._PARAM_COORDS)                          ; Get coords from the stack
    LD B, 0x00                                          ; B=0x00, C=Y coord
    SLA C                                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, ._Y_LOOKUP_TABLE                             ; Base of lookup table in HL
    ADD HL,BC                                           ; Location of the row start in the lookup table
    LD BC,(HL)                                          ; Location of row start
    LD HL,BC                                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+._PARAM_COORDS)                          ; Get coords from the stack
    LD A,B                                              ; Grab the x coord
    OR L                                                ; OR it into memory address
    LD L,A                                              ; Store in L
  
    LD (IX+._RTN_ADDR),HL                               ; Set the return value on the stack
    
    POP IX,BC,HL,AF

    RET

._Y_LOOKUP_TABLE:
	WORD 0xC000, 0xC020, 0xC040, 0xC060, 0xC080, 0xC0A0,  0xC0C0,  0xC0E0
	WORD 0xC800, 0xC820, 0xC840, 0xC860, 0xC880, 0xC8A0,  0xC8C0,  0xC8E0
	WORD 0xD000, 0xD020, 0xD040, 0xD060, 0xD080, 0xD0A0,  0xD0C0,  0xD0E0

inline_print:
    
.CALLER_OFFSET EQU 8
.COORDS_OFFSET EQU 10

    PUSH AF,DE,HL,IX
   
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.CALLER_OFFSET)                           ; Return address
    PUSH HL
    LD DE,(IX+.COORDS_OFFSET)
    PUSH DE
    CALL print_string
    POP DE
    POP DE

    LD A,(HL)
    CP 0x00
    INC HL
    JR Z, .done


.done
    LD (IX+.CALLER_OFFSET),HL
    POP IX,HL,DE,AF

    RET

    MEMORY_USAGE "print",_print_start

    MACRO DEBUG_PRINT text
        IFDEF DEBUG
            PUSH HL

            ; LD HL, (0x00 shl 8)+2
            ; PUSH HL
            ; CALL print.inline_print
            ; BYTE "                 ",0
            ; POP HL

            LD HL, (0x01 shl 8)+2
            PUSH HL
            CALL print.inline_print
            BYTE text,0
            POP HL
            
            POP HL
        ENDIF
    ENDM

    ENDMODULE

