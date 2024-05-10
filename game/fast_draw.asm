    MODULE fast_draw

_module_start:

_buffer_stack_top:  BLOCK 2                             ; This points to the next free location on the stack
_BUFFER_STACK:      BLOCK 512  

init:
    PUSH HL
    
    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL
    
    POP HL

    RET

    ; For 16 bit wide sprite => 24 bits of pre-shifted image
    MACRO COPY_LINE_16
        POP HL                                          ; Get the address written to in the off screen buffer
        LD D,H                                          ; Copy address in DE - this will become the screen address                  
        LD E,L
        RES 7,D                                         ; Reset bit 7 to make screen address
        LDI                                             ; LD (DE),(HL) INC HL INC DE DEC BC - 
        LDI                                             ; LD (screen_ptr), (buffer_ptr), INC screen_ptr, INC buffer_pointer, DEC loop_counter
        LDI 
    ENDM
    
fast_copy_buffer_to_screen_16x8:
    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (.stack_ptr),SP                                  ; Store current SP to restore at end

    LD SP,_BUFFER_STACK                                 ; Subtract the start of stack area (low mem)
    LD HL,(_buffer_stack_top)                           ; from current stack pointer (first free byte)
    LD A,L
    SUB low _BUFFER_STACK
    LD C,A
    LD A,H
    SBC high _BUFFER_STACK
    LD B,A
    
    SRL B                                               ; Divide the result by two to give number of loops to                                 
    RR C                                                ; run as we are dealing with word chunks on the stack 

    LD H,B                                              ; Tripple BC - As only the first address of each row was added to the stack
    LD L,C
    ADD HL,BC
    ADD HL,BC
    LD B,H
    LD C,L

.copy_loop
    LD A,B                                              ; Is the copy counter zero?
    OR C
    JP Z,.done                                          ; Yes - done

.more                                     
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK                                 ; Reset the stack
    LD (_buffer_stack_top),HL
    
    LD SP,(.stack_ptr)                                  ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

.stack_ptr:        BLOCK 2

;------------------------------------------------------------------------------
; Render a single row of a 16 bit wide (24 bits pre-shifted)
;
; Usage:
;   ._x_offset_stash - contains the x offset within the y row
;   BC - contains the address in the offscreen buffer at the start of the y row
;   SP - is set to the current location of the sprite/mask data
; Return values:
;   -
;
; Registers modified:
;   AF, DE and HL
;------------------------------------------------------------------------------

    ; Modifies 
    MACRO RENDER_ROW 
        
        ; Calculate buffer start address -> DE
        LD HL,BC                                        ; Buffer address
        LD DE,(HL)                                          
        LD A,(.x_offset)                                ; Merge in x offset
        OR E
        LD E,A

        ; Record that we are writing to the double buffer
        LD HL,(_buffer_stack_top)                       ; Top of stack address        
        LD (HL),DE                                      ; Write screen buffer address at top of stack            
        INC HL                                          ; Increase the stack top pointer +2 as a word was written
        INC HL
        LD (_buffer_stack_top),HL

        ; First word of mask/data
        POP HL                                          ; Mask and sprite data
        LD A,(DE)
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

        ; Second word of mask/data
        INC DE
        POP HL                                          ; Mask and sprite data
        LD A,(DE)
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

        ; Third word of mask/data
        INC DE
        POP HL                                          ; Mask and sprite data
        LD A,(DE)
        AND L                                           ; Mask
        OR H                                            ; Sprite
        LD (DE),A

    ENDM

;------------------------------------------------------------------------------
; Draw a sprite that must be 16 wide (pre-shifted, 24 bits in total)
; and 8 tall.
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH address of pre-shifted sprite lookup table
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

fast_draw_sprite_16x8:

._PARAM_COORDS:            EQU 14                       ; Sprite coordinates
._PARAM_SPRITE_DATA:       EQU 12                       ; Sprite pre-shifted data lookup table
        
    DI                                                  ; Disable interrupts as we'll be messing with the SP

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   
  
    ; Initialize the collision flag
    LD HL,draw_common.collided                      
    LD (HL),0x00

    ; Get and store the coords
    LD HL,(IX+._PARAM_COORDS)                           ; Grab the pixel coords
    LD (.coords),HL                                     ; And store for later 

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+._PARAM_SPRITE_DATA)                      ; Start of sprite lookup table
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

    LD (.stack_ptr),SP                                  ; Store current SP to restore at end
    LD HL,DE
    LD SP,HL

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
    
    LD SP,(.stack_ptr)                                 ; Restore the original SP

    POP IX,HL,DE,BC,AF   

    EI
    
    IFDEF AUTO_FLUSH
        call fast_copy_buffer_to_screen_16x8
    ENDIF

    RET

.coords:                                               ; Sprite coords
.y_coord:              BLOCK 1
.x_coord:              BLOCK 1
.stack_ptr:            BLOCK 2                         ; Safe store for stack pointer
.x_offset:             BLOCK 1

    MEMORY_USAGE "fast draw       ",_module_start

    ENDMODULE