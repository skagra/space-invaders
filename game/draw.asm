    MODULE draw

SCREEN_WIDTH_PIXELS:    EQU 256
SCREEN_HEIGHT_PIXELS:   EQU 192
SCREEN_WIDTH_CHARS:     EQU 32
SCREEN_HEIGHT_CHARS:    EQU 24

; Flash attribute
CA_FLASH:       EQU 0b10000000

; Bright attribute
CA_BRIGHT:      EQU 0b01000000

; Colour definitions
CA_COL_BLACK:   EQU 0b000
CA_COL_BLUE:    EQU 0b001
CA_COL_RED:     EQU 0b010
CA_COL_MAGENTA: EQU 0b011
CA_COL_GREEN:   EQU 0b100
CA_COL_CYAN:    EQU 0b101
CA_COL_YELLOW:  EQU 0b110
CA_COL_WHITE:   EQU 0b111

; Foreground colours
CA_FG_BLACK:    EQU CA_COL_BLACK 
CA_FG_BLUE:     EQU CA_COL_BLUE
CA_FG_RED:      EQU CA_COL_RED
CA_FG_MAGENTA:  EQU CA_COL_MAGENTA
CA_FG_GREEN:    EQU CA_COL_GREEN
CA_FG_CYAN:     EQU CA_COL_CYAN
CA_FG_YELLOW:   EQU CA_COL_YELLOW
CA_FG_WHITE:    EQU CA_COL_WHITE

; Background colours
CA_BG_BLACK:    EQU CA_COL_BLACK << 3
CA_BG_BLUE:     EQU CA_COL_BLUE << 3
CA_BG_RED:      EQU CA_COL_RED << 3
CA_BG_MAGENTA:  EQU CA_COL_MAGENTA << 3
CA_BG_GREEN:    EQU CA_COL_GREEN << 3
CA_BG_CYAN:     EQU CA_COL_CYAN << 3
CA_BG_YELLOW:   EQU CA_COL_YELLOW << 3
CA_BG_WHITE:    EQU CA_COL_WHITE << 3

;------------------------------------------------------------------------------
; Erase the screen
;
; Usage:
;   -
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

wipe_screen:
    PUSH HL,IX    

    ; Set up call to utils.fill_mem
    LD HL,0x0000                        ; Fill with zero values (blank)
    PUSH HL
    LD HL,mmap.SCREEN_START             ; Start of screen area
    PUSH HL
    LD HL, mmap.SCREEN_SIZE             ; Length of screen area
    PUSH HL
    CALL utils.fill_mem                 ; Erase the screen
    POP HL                              ; Ditch the supplied parameters
    POP HL
    POP HL

    POP IX,HL

    RET

;------------------------------------------------------------------------------
; Fill screen with given colour attributes
;
; Usage:
;   PUSH attribute byte (in high byte of pair)
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

FSA_PARAM_ATTRIBUTE: EQU 7                  ; Colour attributes

fill_screen_attributes:
    PUSH HL,IX   

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    ; Set up call to utils.fill_mem
    LD HL, (ix+FSA_PARAM_ATTRIBUTE)         ; Get the colour attribute
    PUSH HL                             
    LD HL,mmap.SCREEN_ATTR_START        ; Start of the screen attribute area
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_SIZE         ; Length of the screen attribute area
    PUSH HL
    CALL utils.fill_mem                 ; Fill the screen attribute area
    POP HL                              ; Ditch the supplied parameters
    POP HL
    POP HL 

    POP IX,HL

    RET

;------------------------------------------------------------------------------
; Fill a rectangle with the given attribute
;
; The structure of the screen memory address is formed as follows:
;
;   15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
;   1  0  0  1  1 0  Y4 Y3 Y2 Y1 Y0 X4 X3 X2 X1 X0
; 
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH dimensions word - X dim high byte, Y dim low byte
;   PUSH color attribute - In low byte of pair
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

FSAR_PARAM_TOP_LEFT:          EQU 16
FSAR_PARAM_DIM:               EQU 14
FSAR_PARAM_ATTRIBUTE:         EQU 12

fill_screen_attributes_rect:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+FSAR_PARAM_ATTRIBUTE)     ; Get the colour attribute
    LD A,L
    LD (fsar_attribute),A

    LD HL,(IX+FSAR_PARAM_TOP_LEFT)      ; Top left of rect to fill
    LD (fsar_top_left),HL

    LD HL,(IX+FSAR_PARAM_DIM)           ; Width and hight of rect to fill
    LD (fsar_dim),HL

    ; Calculate the starting address
    LD DE, mmap.SCREEN_ATTR_START       ; Base address of attribute map
    LD A,(fsar_x)                       ; Set low order byte from x coord
    LD E,A 
    
    LD H,0x00                           ; Take y coord
    LD A,(fsar_y)                       ; Multiple x32
    LD L,A             
    SLA L
    RL H
    SLA L
    RL H
    SLA L
    RL H
    SLA L
    RL H
    SLA L
    RL H
    ADD DE,HL                           ; DE will track memory to write                       

    ; Calculate line step bytes
    LD A,(fsar_dim_width)               ; Subtract the width of the block 
    LD B,A                              ; from bytes in a line
    LD A, SCREEN_WIDTH_CHARS
    SUB B
    LD (fsar_line_step_bytes),A         ; Store away line step update
    
    LD A,(fsar_dim_height)              ; Set y loop counter (B) from height
    LD B,A

fsar_y_loop:
    LD A,(fsar_dim_width)               ; Set x loop counter (C) from width
    LD C,A

fsar_x_loop:
    LD A, (fsar_attribute)              ; Get the screen attribute
    LD (DE),A                           ; Store at current screen map location
    INC DE                              ; Move to next screen map location

    DEC C                               ; Any more to do in this line?
    JR NZ,fsar_x_loop                   

    LD H,0x00                           ; Move to next line
    LD A,(fsar_line_step_bytes)
    LD L,A
    ADD DE,HL

    DEC B                               ; Any more lines to do?
    JR NZ,fsar_y_loop

    POP IX,HL,DE,BC,AF

    RET

fsar_top_left:  
fsar_y:             BLOCK 1
fsar_x:             BLOCK 1
fsar_dim:
fsar_dim_height:    BLOCK 1
fsar_dim_width:     BLOCK 1
fsar_attribute:     BLOCK 1
fsar_line_step_bytes:   BLOCK 1

;------------------------------------------------------------------------------
; Translate x,y coordinates to a screen map memory location
;
; The structure of the screen memory address is formed as follows:
;
;   15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
;   0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X7 X6 X5 X4 X3
; 
; As X2,X1,X0 gives bit offset with screen byte they are ignored here
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;
; Return values:
;   HL - Screen address
;
; Registers modified:
;   HL
;------------------------------------------------------------------------------

CTM_PARAM_COORDS:   EQU 8               ; Coordinates

coords_to_mem:
    PUSH AF,BC,IX
   
    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD BC, (IX+CTM_PARAM_COORDS)        ; Get coords from the black

    LD A,C                              ; Calculate Y2,Y1,Y0
    AND 0b00000111                      ; Mask out unwanted bits
    OR 0b01000000                       ; Set base address of screen
    LD H,A                              ; Store in H
    LD A,C                              ; Calculate Y7,Y6
    RRA                                 ; Shift to position
    RRA
    RRA
    AND 0b00011000                      ; Mask out unwanted bits
    OR H                                ; OR with Y2,Y1,Y0
    LD H,A                              ; Store in H
    LD A,C                              ; Calculate Y5,Y4,Y3
    RLA                                 ; Shift to position
    RLA
    AND 0b11100000                      ; Mask out unwanted bits
    LD L,A                              ; Store in L
    LD A,B                              ; Calculate X7,X6,X5,X4,X3
    RRA                                 ; Shift into position
    RRA
    RRA
    AND 0b00011111                      ; Mask out unwanted bits
    OR L                                ; OR with Y5,Y4,Y3
    LD L,A                              ; Store in L

    POP IX,BC,AF

    RET

;------------------------------------------------------------------------------
; Draw a sprite
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH dimensions word - X dim high byte, Y dim low byte
;   PUSH address of pre-shifted sprite lookup table
;   PUSH address of pre-shifted mask lookup table
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

DS_PARAM_COORDS:            EQU 18      ; Sprite coordinates
DS_PARAM_DIMS:              EQU 16      ; Sprite dimensions
DS_PARAM_SPRITE_DATA:       EQU 14      ; Sprite pre-shifted data lookup table
DS_PARAM_MASK_DATA:         EQU 12      ; Mask pre-shifted data lookup table

draw_sprite:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Point IX to the stack
    ADD IX,SP                           

    ; Get and store the coords
    LD HL,(IX+DS_PARAM_COORDS)          ; Grab the pixel coords
    LD (ds_coords),HL                   ; And store for later (only the Y coord gets updated)

    ; Get and store the dimensions
    LD HL,(IX+DS_PARAM_DIMS)            ; Grab dimension data (X in characters, Y in pixel lines)
    LD (ds_dims),HL                     ; And store for later

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+DS_PARAM_SPRITE_DATA)     ; Start of sprite lookup table
    LD A,(ds_x_coord)                   ; X coord
    AND 0b00000111                      ; Calculate the X offset withing the character cell
    SLA A                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                           ; Add the offset into the table to the base of the table
    LD DE, (HL)                         ; Lookup the sprite data in the table
    LD (ds_sprite_data_ptr), DE         ; Points to sprite data
     
    ; Find the correct shifted version of the mask data
    LD HL,(IX+DS_PARAM_MASK_DATA)       ; Start of mask lookup table
    LD A,(ds_x_coord)                   ; X coord
    AND 0b00000111                      ; Calculate the X offset withing the character cell
    SLA A                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                           ; Add the offset into the table to the base of the table
    LD DE, (HL)                         ; Lookup the sprite data in the table
    LD (ds_mask_data_ptr), DE           ; Points to mask data

    LD A,(ds_y_dim)                     ; Y loop counter set from y dimension
    LD C,A

ds_y_loop:   
    LD HL,(ds_coords)                   ; Current screen coords
    PUSH HL                 
    CALL coords_to_mem                  ; Get Memory location of screen byte into HL
    LD (ds_screen_mem_loc),HL           ; Store the start of the row in screen memory
    POP HL

    LD A,(ds_x_dim)                     ; X dim loop counter - character cells
    LD B,A

ds_x_loop:
    ; Draw mask -->
    LD HL,(ds_mask_data_ptr)            ; Get the mask data
    LD A,(HL)                                  
    CPL                                 ; Compliment the mask
    LD HL,(ds_screen_mem_loc)           ; Get screen byte
    AND (HL)                            ; And notted mask with screen byte
    LD (HL),A                           ; Write screen memory
  
    ; Done writing mask data, move pointer on for next iteration                     
    LD HL,(ds_mask_data_ptr)            ; Move to next byte of mask data
    INC HL
    LD (ds_mask_data_ptr),HL
    ; <-- End of draw mask

    ; Draw sprite -->
    LD HL,(ds_sprite_data_ptr)          ; Get sprite data
    LD A,(HL)                                     
    LD HL,(ds_screen_mem_loc)           ; Get screen byte
    OR (HL)                             ; Or sprite data with screen byte
    LD (HL),A                           ; Write screen memory

    ; Done writing sprite data, move pointer on for next iteration                                 
    LD HL,(ds_sprite_data_ptr)          ; Move to next byte of sprite data
    INC HL
    LD (ds_sprite_data_ptr),HL
    ; <-- End of draw sprite

    ; Done writing current byte of current row - move to next X cell 
    LD HL,(ds_screen_mem_loc)           ; Move to next X cell
    INC HL              
    LD (ds_screen_mem_loc), HL
    
    ; Are we done writing this pixel row?
    DEC B                               ; Decrease the X loop counter
    JR NZ,ds_x_loop                     ; Next X

    ; Move to next pixel row   
    LD HL,(ds_coords)                   ; Next pixel row
    INC HL                              
    LD (ds_coords), HL
    
    ; Is there another pixel row to write?
    DEC C                               ; Y loop counter
    JP NZ,ds_y_loop

    POP IX,HL,DE,BC,AF   

    RET

ds_coords:                              ; Sprite location (y is updated to line being drawn)
ds_y_coord:         BLOCK 1
ds_x_coord:         BLOCK 1
ds_dims:                                ; Sprite dimensions
ds_y_dim:           BLOCK 1
ds_x_dim:           BLOCK 1
ds_sprite_data_ptr  BLOCK 2             ; Pointer to current sprite data byte
ds_mask_data_ptr    BLOCK 2             ; Pointer to current mask data byte
ds_screen_mem_loc:  BLOCK 2             ; Pointer to current screen byte

    ENDMODULE

   

    