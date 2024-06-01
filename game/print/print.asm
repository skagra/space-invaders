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
    
.PARAM_STRING_PTR: EQU 14
.PARAM_COORDS: EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Calculate memory location from coords
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL char_coords_to_mem
    POP HL                                              ; Grab return value - screen address
    POP DE        

    LD DE,(IX+.PARAM_STRING_PTR)                        ; Pointer to current character

.character_loop:
    ; Get character to print
    LD A,(DE)                                           ; Have we hit the end of the string?
    AND A
    JR Z,.ps_done

    LD B,0x00                                           ; Character to print
    LD C,A
    PUSH BC
    
    PUSH HL                                             ; On-screen address                                    

    CALL _print_char_at_screen_mem                      ; Print character

    POP BC                                              ; Result
    POP BC                                              ; Ditch the parameter

    INC DE                                              ; Move to the next character
    INC HL                                              ; Next screen address

    JR .character_loop                                  ; Next character

.ps_done:
    POP IX,HL,DE,BC,AF

    RET

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

.PARAM_COORDS:   EQU 12                                 ; Coordinates
.RTN_ADDR:       EQU 10                                 ; Return address

    PUSH AF,BC,HL,IX
   
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Y row
    LD BC, (IX+.PARAM_COORDS)                           ; Get coords from the stack
    LD B, 0x00                                          ; B=0x00, C=Y coord
    SLA C                                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, .Y_LOOKUP_TABLE                              ; Base of lookup table in HL
    ADD HL,BC                                           ; Location of the row start in the lookup table
    LD BC,(HL)                                          ; Location of row start
    LD HL,BC                                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+.PARAM_COORDS)                           ; Get coords from the stack
    LD A,B                                              ; Grab the x coord
    OR L                                                ; OR it into memory address
    LD L,A                                              ; Store in L
  
    LD (IX+.RTN_ADDR),HL                                ; Set the return value on the stack
    
    POP IX,BC,HL,AF

    RET

.Y_LOOKUP_TABLE:
    IFDEF DIRECT_DRAW
        WORD 0x4000, 0x4020, 0x4040, 0x4060, 0x4080, 0x40A0,  0x40C0,  0x40E0
        WORD 0x4800, 0x4820, 0x4840, 0x4860, 0x4880, 0x48A0,  0x48C0,  0x48E0
        WORD 0x5000, 0x5020, 0x5040, 0x5060, 0x5080, 0x50A0,  0x50C0,  0x50E0
    ELSE
        WORD 0xC000, 0xC020, 0xC040, 0xC060, 0xC080, 0xC0A0,  0xC0C0,  0xC0E0
        WORD 0xC800, 0xC820, 0xC840, 0xC860, 0xC880, 0xC8A0,  0xC8C0,  0xC8E0
	    WORD 0xD000, 0xD020, 0xD040, 0xD060, 0xD080, 0xD0A0,  0xD0C0,  0xD0E0   
    ENDIF

inline_print:
    
.PARAM_CALLER EQU 8
.PARAM_COORDS EQU 10

    PUSH AF,DE,HL,IX
   
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_CALLER)                            ; Return address
    PUSH HL
    LD DE,(IX+.PARAM_COORDS)
    PUSH DE
    CALL print_string
    POP DE
    POP DE

.loop
    LD A,(HL)
    INC HL
    CP 0x00
    JR NZ, .loop

.done
    LD (IX+.PARAM_CALLER),HL
    
    POP IX,HL,DE,AF

    RET

    MACRO DEBUG_PRINT text
        IFDEF DEBUG
            PUSH HL

            LD HL, (0x00 shl 8)+2
            PUSH HL
            CALL print.inline_print
            BYTE "                       ",0
            POP HL

            LD HL, (0x00 shl 8)+2
            PUSH HL
            CALL print.inline_print
            BYTE text,0
            POP HL
            
            POP HL
        ENDIF
    ENDM

_print_char_at_screen_mem:

.PARAM_CHAR:    EQU 14
.PARAM_ADDRESS: EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_ADDRESS)                           ; Address in screen memory
    LD (.print_mem_ptr),HL                              

    ; Find the bitmap for the required character
    LD HL,character_set.CHARACTER_SET_BASE-(32*8)       ; Then the char data is at character code * 8 offset
    LD DE,(IX+.PARAM_CHAR)                              ; Get the char to draw
    SLA E                                               ; Multiply char code by 8
    RL D
    SLA E
    RL D
    SLA E
    RL D
    ADD HL,DE                                           ; HL now points at character bitmap
    LD (.char_data_ptr), HL                             ; Store pointer to first byte of character data 

    LD B,0x08                                           ; Loop counter for drawing bytes of character data

.pc_y_loop:
    LD HL,(.char_data_ptr)                              ; Get character bits to print
    LD A,(HL)
    
    INC HL                                              ; Move character data pointer to next byte
    LD (.char_data_ptr),HL

    LD HL,(.print_mem_ptr)                              ; Write character bits into screen memory
    LD (HL),A

    IFNDEF DIRECT_DRAW
        ; Record that we are writing to the double buffer
        LD HL,(draw._buffer_stack_top)                  ; Top of stack address
        LD DE,(.print_mem_ptr)       
        LD (HL),DE                                      ; Write screen buffer address at top of stack            
        INC HL                                          ; Increase the stack top pointer +2 as a word was written
        INC HL
        LD (draw._buffer_stack_top),HL
    ENDIF

    LD HL,(.print_mem_ptr)
    LD DE,0x0100                                        ; Move pointer to screen memory down a line
    ADD HL,DE
    LD (.print_mem_ptr),HL
                                          
    DJNZ .pc_y_loop                                     ; Done?

    POP IX,HL,DE,BC,AF

    IFDEF AUTO_FLUSH
        call draw.flush_buffer_to_screen
    ENDIF

    RET

.print_mem_ptr:  BLOCK 2
.char_data_ptr:  BLOCK 2

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

.PARAM_CHAR:   EQU 12
.PARAM_COORDS: EQU 10

    PUSH AF,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Calculate memory location from coords
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL char_coords_to_mem
    POP HL                                              ; Grab return value
    POP DE                                              

    LD DE,(IX+.PARAM_CHAR)
    PUSH DE
    PUSH HL
    CALL _print_char_at_screen_mem
    POP HL
    POP HL

    POP IX,HL,DE,AF

    RET
    
