;------------------------------------------------------------------------------
;
; Draw a sprite and flush the off-screen buffer to the screen
;
; Usage:
;   PUSH rr - Coords X high byte, Y low byte
;   PUSH rr - Dimensions X dim high byte, Y dim low byte
;   PUSH rr - Address of pre-shifted sprite data
;   CALL draw_sprite_and_flush_buffer
;   POP rr,rr,rr
;------------------------------------------------------------------------------

draw_sprite_and_flush_buffer:

.PARAM_COORDS:            EQU 4                         ; Sprite coordinates
.PARAM_DIMS:              EQU 2                         ; Sprite dimensions
.PARAM_SPRITE_DATA:       EQU 0                         ; Sprite pre-shifted data lookup table
    
    PUSH HL,IX

    PARAMS_IX 2                                         ; Get the stack pointer                                               

    ; Pass parameters onto draw_sprite
    LD HL,(IX+.PARAM_COORDS)
    PUSH HL
    LD HL,(IX+.PARAM_DIMS)
    PUSH HL
    LD HL,(IX+.PARAM_SPRITE_DATA)
    PUSH HL

    LD H,0x00
    LD L,utils.FALSE_VALUE
    PUSH HL 

    LD HL,collision.dummy_collision                     ; Where to record collision data
    PUSH HL

    CALL draw.draw_sprite

    POP HL
    POP HL 
    POP HL
    POP HL
    POP HL

    ; Flush the off-screen buffer
    CALL double_buffer.flush_buffer_to_screen

    POP IX,HL

    RET

;------------------------------------------------------------------------------
; Draw a sprite
;
; Usage:
;   PUSH rr - Coords  - X high byte, Y low byte
;   PUSH rr - Dimensions  - X dim high byte, Y dim low byte
;   PUSH rr - Sprite data
;   PUSH rr - Blanking (or drawing) - TRUE_VALUE or FALSE_VALUE
;   PUSH rr - Struct to record any collision found during drawing
;   CALL draw_sprite
;   POP rr,rr,rr,rr,rr
;------------------------------------------------------------------------------

draw_sprite:

.PARAM_COORDS:            EQU 8                         ; Sprite coordinates
.PARAM_DIMS:              EQU 6                         ; Sprite dimensions
.PARAM_SPRITE_DATA:       EQU 4                         ; Sprite pre-shifted data lookup table
.PARAM_BLANKING:          EQU 2                         ; Drawing or blanking?                   
.PARAM_COLLISION_STRUCT:  EQU 0

    DI 

    PUSH AF,BC,DE,HL,IX,IY

    PARAMS_IX 6                                         ; Get the stack pointer                                      

    ; Initialize the collision flag
    LD HL,(IX+.PARAM_COLLISION_STRUCT)                  
    LD IY,0x0000
    LD IY,HL                     
    LD (IY+collision.COLLISION_OFFSET_COLLIDED),utils.FALSE_VALUE

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

    ; Point SP to the sprite data
    LD (.stack_ptr),SP                                  ; Store current SP to restore at end
    LD HL,DE                                            ; Set the SP to the start of the sprite data
    LD SP,HL

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
    LD HL,draw_utils.Y_MEM_ROW_LOOKUP                   ; Base of lookup table in HL
    ADD HL,BC                                           ; Location of the row start in the lookup table
    LD (.y_lookup_table_ptr), HL

    LD A,(.y_dim)                                       ; Y dim loop counter
    LD C,A

.y_loop:
    LD A,(.x_dim)                                       ; X dim loop counter - character cells
    LD B,A

    ; Calculate buffer start address -> DE
    LD HL,(.y_lookup_table_ptr)                         ; Buffer address
    LD DE,(HL)    
    IFDEF DIRECT_DRAW
        RES 7,D
    ENDIF                                      
    LD A,(.x_offset)                                    ; Merge in x offset
    OR E
    LD E,A
    LD (.mem_write_ptr), DE
    
    ; We can increase .y_lookup_table_ptr now as we won't refer to it again until next loop
    INC HL
    INC HL
    LD (.y_lookup_table_ptr),HL

.x_loop:
    IFNDEF DIRECT_DRAW
        ; Record that we are writing to the double buffer
        LD HL,(double_buffer.buffer_stack_top)          ; Top of stack address        
        LD (HL),DE                                      ; Write screen buffer address at top of stack            
        INC HL                                          ; Increase the stack top pointer +2 as a word was written
        INC HL
        LD (double_buffer.buffer_stack_top),HL
    ENDIF

    ; First word of mask/data
    LD DE,(.mem_write_ptr)
    POP HL                                              ; Mask and sprite data
    
    BIT utils.TRUE_BIT,(IX+.PARAM_BLANKING)             ; Blanking or drawing?
    JR NZ,.blanking

    ; Drawing
    BIT utils.TRUE_BIT,(IY+collision.COLLISION_OFFSET_COLLIDED)   ; Has a collision already been recorded?
    JR NZ,.skip_collision_detection

    LD A,(DE)                                           ; Data from screen
    AND H                                               ; And with sprite data to detect collision
    JR Z,.skip_collision_detection                      ; Collided? No

    ; A collision has been detected                  
    LD (IY+collision.COLLISION_OFFSET_COLLIDED),utils.TRUE_VALUE  ; Record the collision
    LD A,(.y_coord)
    LD (IY+collision.COLLISION_OFFSET_Y_COORD),A
    LD A,(.x_coord)
    LD (IY+collision.COLLISION_OFFSET_X_COORD),A

.skip_collision_detection
    ; Write screen data
    LD A,(DE)                                           ; Data from screen
    AND L                                               ; And the mask
    OR H                                                ; Or the sprite data
    LD (DE),A                                           ; Write result back to screen

    JR .next_x

.blanking
    ; Blanking
    LD A,(DE)                                           ; Data from screen
    AND L                                               ; And the mask
    LD (DE),A                                           ; Write result back to the screen

.next_x
    ; Next X
    INC DE                                              ; Next X screen byte
    LD (.mem_write_ptr),DE                              

    DEC B
    JR NZ,.x_loop

    ; Is there another pixel row to write?
    DEC C                                               ; Y loop counter
    JP NZ,.y_loop

.done
    LD SP,(.stack_ptr)                                  ; Restore the original SP

    POP IY,IX,HL,DE,BC,AF   

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

.x_offset:             BLOCK 1                          ; X offset into Y line

.y_lookup_table_ptr    BLOCK 2                          ; Y lookup table address
.mem_write_ptr         BLOCK 2                          ; Offscreen screen buffer address

.stack_ptr:            BLOCK 2                          ; Original SP
