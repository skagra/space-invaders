;------------------------------------------------------------------------------
;
; Copies a single row of 24 bits from the off-screen buffer to screen memory
;
; Usage:
;   SP - Address in the draw stack which points to screen memory written
;
; Return values:
;   -
;
; Registers modified:
;   HL,DE
;
;------------------------------------------------------------------------------

    MACRO COPY_LINE_16
        POP HL                                          ; Get the address written to in the off-screen buffer
        LD D,H                                          ; Copy address in DE - this will become the screen memory address                  
        LD E,L
        RES 7,D                                         ; Reset bit 7 to calculate the screen memory address
        LDI                                             ; LD (DE),(HL) INC HL INC DE DEC BC =>
        LDI                                             ; LD (screen_ptr), (buffer_ptr), INC screen_ptr, INC buffer_pointer, DEC loop_counter
        LDI 
    ENDM

;------------------------------------------------------------------------------
;
; Copies the off-screen buffer to screen memory
;
; Usage:
;   CALL fast_copy_buffer_to_screen_16x8
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

flush_buffer_to_screen_16x8:
    IFDEF DIRECT_DRAW
        RET
    ENDIF

    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (.stack_ptr),SP                                  ; Store current SP to restore later

    ; Check whether there is any work to do
    LD DE,_DRAW_BUFFER_STACK
    LD HL,(_draw_buffer_stack_top)
    SUB HL,DE
    JP Z,.done

    ; Calculate number of iterations needed to flush the draw stack
    LD SP,_DRAW_BUFFER_STACK                            ; Subtract the start of stack area (low mem)
    LD HL,(_draw_buffer_stack_top)                      ; from current stack pointer (first free byte)
    LD A,L
    SUB low _DRAW_BUFFER_STACK
    LD C,A
    LD A,H
    SBC high _DRAW_BUFFER_STACK
    LD B,A
    
    SRL B                                               ; Divide the result by two to give number of loops to                                 
    RR C                                                ; run as we are dealing with word chunks on the stack 

    LD H,B                                              ; Triple BC - As only the first address of each 3 byte
    LD L,C                                              ; row was added to the draw stack
    ADD HL,BC
    ADD HL,BC
    LD B,H
    LD C,L
    
.more                                     
    COPY_LINE_16                                        ; Copy each of the 8 lines of 16 bits (24 pre-shifted)
    COPY_LINE_16                                        ; from the off-screen buffer to screen memory
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16

    JP PE,.more

.done
    LD HL,_DRAW_BUFFER_STACK                            ; Reset the stack
    LD (_draw_buffer_stack_top),HL
    
    LD SP,(.stack_ptr)                                  ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

.stack_ptr: BLOCK 2

;------------------------------------------------------------------------------
;
; Blank a single row of a 16 bit wide (24 bits pre-shifted) sprite to the
; off-screen buffer
;
; Usage:
;   ._x_offset - X offset within the Y row
;   BC - Address in the off-screen buffer at the start of the Y row
;   SP - Location of the sprite/mask data (only the mask is used)
;
; Return values:
;   -
;
; Registers modified:
;   AF, DE and HL
;
;------------------------------------------------------------------------------

    ; Modifies 
    MACRO BLANK_ROW 
        
        ; Adjust the off-screen buffer address to account for the X offset
        LD HL,BC                                        ; Buffer address
        LD DE,(HL)  
        IFDEF DIRECT_DRAW
            RES 7,D
        ENDIF                                  
        LD A,(.x_offset)                                ; Merge in x offset
        OR E
        LD E,A

        IFNDEF DIRECT_DRAW
            ; Record that we are writing to the double buffer
            LD HL,(_draw_buffer_stack_top)              ; Top of draw stack address        
            LD (HL),DE                                  ; Write screen buffer address at top of stack            
            INC HL                                      ; Increase the stack top pointer +2 as a word was written
            INC HL
            LD (_draw_buffer_stack_top),HL
        ENDIF

        ; First word of mask/data
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        LD (DE),A

        ; Second word of mask/data
        INC DE                                          ; Next address in off-screen buffer
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        LD (DE),A

        ; Third word of mask/data
        INC DE                                          ; Next address in off-screen buffer
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        LD (DE),A

    ENDM

;------------------------------------------------------------------------------
;
; Render a single row of a 16 bit wide (24 bits pre-shifted) sprite to the
; off-screen buffer
;
; Usage:
;   ._x_offset - X offset within the Y row
;   BC - Address in the off-screen buffer at the start of the Y row
;   SP - Location of the sprite/mask data
;
; Return values:
;   -
;
; Registers modified:
;   AF, DE and HL
;
;------------------------------------------------------------------------------

    ; Modifies 
    MACRO RENDER_ROW 
        
        ; Adjust the off-screen buffer address to account for the X offset
        LD HL,BC                                        ; Buffer address
        LD DE,(HL)  
        IFDEF DIRECT_DRAW
            RES 7,D
        ENDIF                                  
        LD A,(.x_offset)                                ; Merge in x offset
        OR E
        LD E,A

        IFNDEF DIRECT_DRAW
            ; Record that we are writing to the double buffer
            LD HL,(_draw_buffer_stack_top)              ; Top of draw stack address        
            LD (HL),DE                                  ; Write screen buffer address at top of stack            
            INC HL                                      ; Increase the stack top pointer +2 as a word was written
            INC HL
            LD (_draw_buffer_stack_top),HL
        ENDIF

        ; First word of mask/data
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

        ; Second word of mask/data
        INC DE                                          ; Next address in off-screen buffer
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

        ; Third word of mask/data
        INC DE                                          ; Next address in off-screen buffer
        POP HL                                          ; Mask and sprite data
        LD A,(DE)                                       ; Existing off-screen buffer data
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

    ENDM

;------------------------------------------------------------------------------
;
; Render a sprite that must be 16 wide (pre-shifted, 24 bits in total)
; and 8 tall into the off-screen buffer.
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH address of pre-shifted sprite lookup table
;   PUSH blanking - TRUE_VALUE or FALSE_VALUE
;   CALL fast_draw_sprite_16x8
;   POP rr
;   POP rr
;   POP rr
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

draw_sprite_16x8:

.PARAM_COORDS:            EQU 16                        ; Sprite coordinates
.PARAM_SPRITE_DATA:       EQU 14                        ; Sprite pre-shifted data lookup table
.PARAM_BLANK              EQU 12                        ; Drawing or blanking?

    DI                                                  ; Disable interrupts as we'll be messing with the SP

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   

    ; Get and store coords
    LD HL,(IX+.PARAM_COORDS)                            ; Grab the pixel coords
    LD (.coords),HL                                     ; And store for later 

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+.PARAM_SPRITE_DATA)                       ; Start of sprite lookup table
    LD A,(.x_coord)                                     ; X coord
    AND 0b00000111                                      ; Calculate the X offset within the character cell
    SLA A                                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                                           ; Add the offset into the table to the base of the table                 
    LD DE, (HL)                                         ; Lookup the sprite data ptr in the table

    ; Calculate X7,X6,X5,X4,X3
    LD A,(.x_coord)                                     ; Grab the x coord
    SRL A                                               ; Shift into position
    SRL A
    SRL A
    LD (.x_offset),A

    ; Find the start of the group of entries in the Y lookup table
    LD B, 0x00                                          ; B=0x00, C=Y coord
    LD A,(.y_coord)
    LD C,A
    SLA C                                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, draw_common._Y_MEM_ROW_LOOKUP                ; Base of lookup table in HL
    ADD HL,BC                                           ; Location of the row start in the lookup table
    LD BC,HL

    LD (.stack_ptr),SP                                  ; Store current SP to restore later
    LD HL,DE
    LD SP,HL
    
    LD A,(IX+.PARAM_BLANK)
    BIT utils.TRUE_BIT,A
    JP NZ,.blanking

    ; Drawing (as opposed to blanking)

    ; Render row 0 (top most)
    RENDER_ROW 

    ; Render row 1
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 
    
    ; Render row 2
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 3
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 4
    INC BC                                              ; Next entry in Y lookup table  
    INC BC
    RENDER_ROW 

    ; Render row 5
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 6
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 7 (bottom most)
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 
    
    JP .done

.blanking
    ; Blanking (as opposed to drawing)

    ; Blank row 0 (top most)
    BLANK_ROW 

    ; Blank row 1
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 
    
    ; Blank row 2
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 

    ; Blank row 3
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 

    ; Blank row 4
    INC BC                                              ; Next entry in Y lookup table  
    INC BC
    BLANK_ROW 

    ; Blank row 5
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 

    ; Blank row 6
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 

    ; Blank row 7 (bottom most)
    INC BC                                              ; Next entry in Y lookup table
    INC BC
    BLANK_ROW 

.done
    LD SP,(.stack_ptr)                                  ; Restore the original SP

    POP IX,HL,DE,BC,AF   

    EI
    
    IFDEF AUTO_FLUSH
        call flush_buffer_to_screen_16x8
    ENDIF

    RET

.coords:                                                ; Sprite coords
.y_coord:              BLOCK 1
.x_coord:              BLOCK 1
.stack_ptr:            BLOCK 2                          ; Safe store for stack pointer
.x_offset:             BLOCK 1                          ; Byte offset into row for X coordinate
