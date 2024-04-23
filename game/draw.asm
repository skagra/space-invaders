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

;--------------------------------------------------------------
; Erase screen and fill with given colour attributes
; PUSH color
;--------------------------------------------------------------
FS_PARAM_COLOUR: EQU 7
fill_screen:
    PUSH HL,IX    

    ; Erase contents of screen
    LD HL,0x0000
    PUSH HL
    LD HL,mmap.SCREEN_START
    PUSH HL
    LD HL, mmap.SCREEN_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL
    POP HL
    POP HL

    ; Fill screen with the given colour
    LD  IX,0
    ADD IX,SP
    LD HL, (ix+FS_PARAM_COLOUR)     ; get the bg colour from the stack
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_START
    PUSH HL
    LD HL,mmap.SCREEN_ATTR_SIZE
    PUSH HL
    CALL utils.fill_mem
    POP HL
    POP HL
    POP HL 

    POP IX,HL
    RET

;-------------------------------------------------------------------------
; Translate x,y coordinates to a screen map memory location
;
; This is the structure of the screen memory address
; 15 14	13 12 11 10 9  8  7  6  5  4  3  2  1  0
; 0  1  0  Y7 Y6 Y2 Y1 Y0 Y5 Y4 Y3 X7 X6 X5 X4 X3
; 
; X2 X1 X0 gives bit offset with screen byte, and so are ignored here
;
; Push XY 
; Returns address in HL
;-------------------------------------------------------------------------

CTM_PARAM_COORDS:   EQU 8
coords_to_mem:
    PUSH AF,BC,IX
   
    LD  IX,0
    ADD IX,SP
    LD BC, (IX+CTM_PARAM_COORDS)

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

;------------------------------------------------
; Draw a sprite
;
; PUSH coords
; PUSH sprite data location
; PUSH mask location (NOT used currently)
;------------------------------------------------

DS_PARAM_COORDS:            EQU 18
DS_PARAM_DIMS:              EQU 16
DS_PARAM_SPRITE_DATA:       EQU 14
DS_PARAM_MASK_DATA:         EQU 12

draw_sprite:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0
    ADD IX,SP                           ; Point IX to the stack

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

ds_coords:                              ; Sprite location (only y is updated)
ds_y_coord:         BLOCK 1
ds_x_coord:         BLOCK 1
ds_dims:                                ; Sprite dimensions
ds_y_dim:           BLOCK 1
ds_x_dim:           BLOCK 1
ds_sprite_data_ptr  BLOCK 2             ; Pointer to current sprite data byte
ds_mask_data_ptr    BLOCK 2             ; Pointer to current mask data byte
ds_screen_mem_loc:  BLOCK 2             ; Pointer to current screen byte

    ENDMODULE

   

    