_BUFFER_STACK: BLOCK 512   
_buffer_stack_top: BLOCK 2                              ; This points to the next free location on the stack

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
    PUSH HL

    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL

    RET

;------------------------------------------------------------------------------
;
; Draw a sprite and flush the off-screen buffer to the screen
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH dimensions word - X dim high byte, Y dim low byte
;   PUSH address of pre-shifted sprite lookup table
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

draw_sprite_and_flush_buffer:

.PARAM_COORDS:            EQU 10                        ; Sprite coordinates
.PARAM_DIMS:              EQU 8                         ; Sprite dimensions
.PARAM_SPRITE_DATA:       EQU 6                         ; Sprite pre-shifted data lookup table
    
    PUSH HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   

    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    LD HL,(IX+.PARAM_DIMS)
    PUSH HL
    LD HL,(IX+.PARAM_SPRITE_DATA)
    PUSH HL

    CALL draw.draw_sprite

    POP HL
    POP HL
    POP HL

    CALL flush_buffer_to_screen

    POP IX,HL

    RET

flush_buffer_to_screen:
    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (.stack_stash),SP                                ; Store current SP to restore at end

    LD SP,_BUFFER_STACK                                 ; Subtract start of stack area (low mem)
    LD HL,(_buffer_stack_top)                           ; from current stack pointer (first free byte)
    LD A,L
    SUB low _BUFFER_STACK
    LD L,A
    LD A,H
    SBC high _BUFFER_STACK
    LD H,A
     
    SRL H                                               ; Divide the result by two to give number of loops to run
    RR L                                                ; as we are dealing with word chunks on the stack

.copy_loop
    LD A,H                                              ; Is the copy counter zero?
    OR L
    JP Z,.done                                          ; Yes - done

    DEC HL                                              ; No - decrase the counter

.more
    POP DE                                              ; Get the address written to in the off screen buffer

    LD A,(DE)                                           ; Copy the byte that was written
    RES 7,D
    LD (DE),A

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK                                 ; Reset the stack
    LD (_buffer_stack_top),HL
    
    LD SP,(.stack_stash)                                ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

.stack_stash: BLOCK 2

;------------------------------------------------------------------------------
; Draw a sprite
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH dimensions word - X dim high byte, Y dim low byte
;   PUSH address of pre-shifted sprite lookup table
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

draw_sprite:

.PARAM_COORDS:            EQU 16                        ; Sprite coordinates
.PARAM_DIMS:              EQU 14                        ; Sprite dimensions
.PARAM_SPRITE_DATA:       EQU 12                        ; Sprite pre-shifted data lookup table
    
    DI 

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   

    ; Initialize the collision flag
    LD HL,draw_common.collided                      
    LD (HL),0x00

    ; Get and store the coords
    LD HL,(IX+.PARAM_COORDS)                            ; Grab the pixel coords
    LD (.coords),HL                                     ; And store for later (only the Y coord gets updated)

    ; Get and store the dimensions
    LD HL,(IX+.PARAM_DIMS)                              ; Grab dimension data (X in characters, Y in pixel lines)
    LD (.dims),HL                                       ; And store for later

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+.PARAM_SPRITE_DATA)                       ; Start of sprite lookup table
    LD A,(.x_coord)                                     ; X coord
    AND 0b00000111                                      ; Calculate the X offset within the character cell
    SLA A                                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                                           ; Add the offset into the table to the base of the table                 
    LD DE, (HL)                                         ; Lookup the sprite data ptr in the table
    LD (.sprite_data_ptr), DE

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
    LD (.y_lookup_table_ptr), HL

    LD (.stack_ptr),SP                                  ; Store current SP to restore at end
    LD HL,DE
    LD SP,HL

    LD A,(.y_dim)                                       ; Y dim loop counter
    LD C,A

.y_loop:
    LD A,(.x_dim)                                       ; X dim loop counter - character cells
    LD B,A

    ; Calculate buffer start address -> DE
    LD HL,(.y_lookup_table_ptr)                         ; Buffer address
    LD DE,(HL)                                          
    LD A,(.x_offset)                                    ; Merge in x offset
    OR E
    LD E,A
    LD (.mem_write_ptr), DE
    
    ; We can increase .y_lookup_table_ptr now as we won't referr to it again until next loop
    INC HL
    INC HL
    LD (.y_lookup_table_ptr),HL

.x_loop:
    ; Record that we are writing to the double buffer
    LD HL,(_buffer_stack_top)                           ; Top of stack address        
    LD (HL),DE                                          ; Write screen buffer address at top of stack            
    INC HL                                              ; Increase the stack top pointer +2 as a word was written
    INC HL
    LD (_buffer_stack_top),HL

    ; First word of mask/data
    LD DE,(.mem_write_ptr)
    POP HL                                              ; Mask and sprite data
    
    LD A,(draw_common.collided)                         ; Has a collision already been recorded?
    CP 0x00
    JR NZ,.no_collision

    LD A,(DE)                                           ; Data from screen
    AND H
    JR Z,.no_collision

    LD A,0x01                                           ; Record the collision
    LD (draw_common.collided),A
    LD A,(.y_coord)
    LD (draw_common.collision_y),A
    LD A,(.x_coord)
    LD (draw_common.collision_x),A

.no_collision
    LD A,(DE)                                           ; Data from screen
    AND L
    OR H
    LD (DE),A

    ; Next X
    INC DE
    LD (.mem_write_ptr),DE

    DEC B
    JR NZ,.x_loop

    ; Is there another pixel row to write?
    DEC C                                               ; Y loop counter
    JP NZ,.y_loop

.done
    LD SP,(.stack_ptr)                                  ; Restore the original SP

    POP IX,HL,DE,BC,AF   

    EI
    
    IFDEF AUTO_FLUSH
        call flush_buffer_to_screen
    ENDIF

    RET

.coords:                                                ; Sprite location (Y is updated to line being drawn)
.y_coord:              BLOCK 1
.x_coord:              BLOCK 1
.dims:                                                  ; Sprite dimensions
.y_dim:                BLOCK 1
.x_dim:                BLOCK 1
.sprite_data_ptr       BLOCK 2                          ; Pointer to current sprite data byte
.x_offset:             BLOCK 1
.stack_ptr:            BLOCK 2
.y_lookup_table_ptr    BLOCK 2
.mem_write_ptr         BLOCK 2
