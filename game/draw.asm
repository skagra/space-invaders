    MODULE draw

; Scree dimensions
SCREEN_WIDTH_PIXELS:    EQU 256
SCREEN_HEIGHT_PIXELS:   EQU 192
SCREEN_WIDTH_CHARS:     EQU 32
SCREEN_HEIGHT_CHARS:    EQU 24

; Flash attribute
CA_FLASH:           EQU 0b10000000

; Bright attribute
CA_BRIGHT:          EQU 0b01000000

; Colour definitions
_CA_COL_BLACK:       EQU 0b000
_CA_COL_BLUE:        EQU 0b001
_CA_COL_RED:         EQU 0b010
_CA_COL_MAGENTA:     EQU 0b011
_CA_COL_GREEN:       EQU 0b100
_CA_COL_CYAN:        EQU 0b101
_CA_COL_YELLOW:      EQU 0b110
_CA_COL_WHITE:       EQU 0b111

; Foreground colours
CA_FG_BLACK:    EQU _CA_COL_BLACK 
CA_FG_BLUE:     EQU _CA_COL_BLUE
CA_FG_RED:      EQU _CA_COL_RED
CA_FG_MAGENTA:  EQU _CA_COL_MAGENTA
CA_FG_GREEN:    EQU _CA_COL_GREEN
CA_FG_CYAN:     EQU _CA_COL_CYAN
CA_FG_YELLOW:   EQU _CA_COL_YELLOW
CA_FG_WHITE:    EQU _CA_COL_WHITE

; Background colours
CA_BG_BLACK:    EQU _CA_COL_BLACK << 3
CA_BG_BLUE:     EQU _CA_COL_BLUE << 3
CA_BG_RED:      EQU _CA_COL_RED << 3
CA_BG_MAGENTA:  EQU _CA_COL_MAGENTA << 3
CA_BG_GREEN:    EQU _CA_COL_GREEN << 3
CA_BG_CYAN:     EQU _CA_COL_CYAN << 3
CA_BG_YELLOW:   EQU _CA_COL_YELLOW << 3
CA_BG_WHITE:    EQU _CA_COL_WHITE << 3

; Border colours
BORDER_BLACK:    EQU _CA_COL_BLACK 
BORDER_BLUE:     EQU _CA_COL_BLUE
BORDER_RED:      EQU _CA_COL_RED
BORDER_MAGENTA:  EQU _CA_COL_MAGENTA
BORDER_GREEN:    EQU _CA_COL_GREEN
BORDER_CYAN:     EQU _CA_COL_CYAN
BORDER_YELLOW:   EQU _CA_COL_YELLOW
BORDER_WHITE:    EQU _CA_COL_WHITE

; Collision detection
collided:          BLOCK 1              ; The last draw operation detected a collision

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
; Set the colour of the screen border
;
; Usage:
;   PUSH rr                             ; Colour in LSB
;   CALL set_border
;   POP rr                              ; Ditch the supplied parameter
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

set_border:

._PARAM_BORDER_COLOUR:  EQU 8

    PUSH AF,HL,IX
    
    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+._PARAM_BORDER_COLOUR)

    LD A,L
    OUT (0xFE),A
    
    POP IX,HL,AF
    
    RET

;------------------------------------------------------------------------------
;
; Erase the screen
;
; Usage:
;   CALL wipe_screen
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
;
; Fill screen with given colour attributes
;
; Usage:
;   PUSH rr                             ; Attribute byte in LSB
;   CALL fill_screen_attributes
;   POP rr                              ; Ditch the supplied parameter
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

fill_screen_attributes:

._PARAM_ATTRIBUTE: EQU 6                ; Colour attributes

    PUSH HL,IX   

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    ; Set up call to utils.fill_mem
    LD HL, (ix+._PARAM_ATTRIBUTE)       ; Get the colour attribute
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
;
; Fill a rectangle with the given attribute
;
; The structure of the screen memory address is formed as follows:
;
;   15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
;   1  0  0  1  1 0  Y4 Y3 Y2 Y1 Y0 X4 X3 X2 X1 X0
; 
; Usage:
;   PUSH rr                             ; Cell coords of top left X MSB, Y LSB
;   PUSH rr                             ; Rectange dimensions X MSB, Y LSB
;   PUSH rr                             ; Colour attribute in LSB
;   CALL fill_screen_attributes_rect
;   POP rr                              ; Ditch the supplied parameters
;   POP rr
;   POP rr
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

fill_screen_attributes_rect:

._PARAM_TOP_LEFT:          EQU 16
._PARAM_DIM:               EQU 14
._PARAM_ATTRIBUTE:         EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+._PARAM_ATTRIBUTE)        ; Get the colour attribute
    LD A,L
    LD (._attribute),A

    LD HL,(IX+._PARAM_TOP_LEFT)         ; Top left of rect to fill
    LD (._top_left),HL

    LD HL,(IX+._PARAM_DIM)              ; Width and hight of rect to fill
    LD (._dim),HL

    ; Calculate the starting address
    LD DE, mmap.SCREEN_ATTR_START       ; Base address of attribute map
    LD A,(._x)                          ; Set low order byte from x coord
    LD E,A 
    
    LD H,0x00                           ; Take y coord
    LD A,(._y)                          ; Multiple x32
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
    LD A,(._dim_width)                  ; Subtract the width of the block 
    LD B,A                              ; from bytes in a line
    LD A, SCREEN_WIDTH_CHARS
    SUB B
    LD (._line_step_bytes),A            ; Store away line step update
    
    LD A,(._dim_height)                 ; Set y loop counter (B) from height
    LD B,A

.y_loop:
    LD A,(._dim_width)                  ; Set x loop counter (C) from width
    LD C,A

._x_loop:
    LD A, (._attribute)                 ; Get the screen attribute
    LD (DE),A                           ; Store at current screen map location
    INC DE                              ; Move to next screen map location

    DEC C                               ; Any more to do in this line?
    JR NZ,._x_loop                   

    LD H,0x00                           ; Move to next line
    LD A,(._line_step_bytes)
    LD L,A
    ADD DE,HL

    DEC B                               ; Any more lines to do?
    JR NZ,.y_loop

    POP IX,HL,DE,BC,AF

    RET

._top_left:  
._y:                 BLOCK 1
._x:                 BLOCK 1
._dim:
._dim_height:        BLOCK 1
._dim_width:         BLOCK 1
._attribute:         BLOCK 1
._line_step_bytes:   BLOCK 1

;------------------------------------------------------------------------------
;
; Fill a stripe across the screen with the given attribute
;
; Usage:
;   PUSH rr                             ; Top Y in MSB, Height in LSB
;   PUSH rr                             ; Attribute in LSB
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

fill_screen_attribute_stripe:

._PARAM_Y:      EQU 12
._PARAM_ATTR:   EQU 10

    PUSH BC,DE,HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL, (IX+._PARAM_Y)               ; H = Y coord, L = height
    LD BC, (IX+._PARAM_ATTR)            ; C = Attribute   

    ; XY Coords
    LD D,0x00;                          ; X=0
    LD E,H                              ; Y as supplied
    PUSH DE

    ; XY Dimensions
    LD D,SCREEN_WIDTH_CHARS             ; X dimension full screen width
    LD E,L                              ; Y dimension as supplied
    PUSH DE

    PUSH BC                             ; Colour attribute

    call fill_screen_attributes_rect

    POP BC
    POP DE
    POP DE

    POP  IX,HL,DE,BC  

    RET

;------------------------------------------------------------------------------
;
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
;   PUSH rr                             ; Coords word X MSB Y LSB
;   PUSH rr                             ; Space for return value
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

coords_to_mem:

._PARAM_COORDS:   EQU 12                ; Coordinates
._RTN_MEM:        EQU 10                ; Memory location return value

    PUSH AF,BC,HL,IX
   
    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD BC, (IX+._PARAM_COORDS)          ; Get coords from the stack
    LD B, 0x00                          ; B=0x00, C=Y coord
    SLA C                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, ._Y_LOOKUP_TABLE             ; Base of lookup table in HL
    ADD HL,BC                           ; Location of the row start in the lookup table
    LD BC,(HL)                          ; Location of row start
    LD HL,BC                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+._PARAM_COORDS)          ; Get coords from the stack
    LD A,B                              ; Grab the x coord
    SRL A                               ; Shift into position
    SRL A
    SRL A
    OR L                                ; OR with Y5,Y4,Y3
    LD L,A                              ; Store in L
  
    LD (IX+._RTN_MEM),HL                ; Put the return value on the stack

    POP IX,HL,BC,AF

    RET

._Y_LOOKUP_TABLE:
	WORD 0x4000, 0x4100, 0x4200, 0x4300, 0x4400, 0x4500, 0x4600, 0x4700
	WORD 0x4020, 0x4120, 0x4220, 0x4320, 0x4420, 0x4520, 0x4620, 0x4720
	WORD 0x4040, 0x4140, 0x4240, 0x4340, 0x4440, 0x4540, 0x4640, 0x4740
	WORD 0x4060, 0x4160, 0x4260, 0x4360, 0x4460, 0x4560, 0x4660, 0x4760
	WORD 0x4080, 0x4180, 0x4280, 0x4380, 0x4480, 0x4580, 0x4680, 0x4780
	WORD 0x40A0, 0x41A0, 0x42A0, 0x43A0, 0x44A0, 0x45A0, 0x46A0, 0x47A0
	WORD 0x40C0, 0x41C0, 0x42C0, 0x43C0, 0x44C0, 0x45C0, 0x46C0, 0x47C0
	WORD 0x40E0, 0x41E0, 0x42E0, 0x43E0, 0x44E0, 0x45E0, 0x46E0, 0x47E0
	WORD 0x4800, 0x4900, 0x4A00, 0x4B00, 0x4C00, 0x4D00, 0x4E00, 0x4F00
	WORD 0x4820, 0x4920, 0x4A20, 0x4B20, 0x4C20, 0x4D20, 0x4E20, 0x4F20
	WORD 0x4840, 0x4940, 0x4A40, 0x4B40, 0x4C40, 0x4D40, 0x4E40, 0x4F40
	WORD 0x4860, 0x4960, 0x4A60, 0x4B60, 0x4C60, 0x4D60, 0x4E60, 0x4F60
	WORD 0x4880, 0x4980, 0x4A80, 0x4B80, 0x4C80, 0x4D80, 0x4E80, 0x4F80
	WORD 0x48A0, 0x49A0, 0x4AA0, 0x4BA0, 0x4CA0, 0x4DA0, 0x4EA0, 0x4FA0
	WORD 0x48C0, 0x49C0, 0x4AC0, 0x4BC0, 0x4CC0, 0x4DC0, 0x4EC0, 0x4FC0
	WORD 0x48E0, 0x49E0, 0x4AE0, 0x4BE0, 0x4CE0, 0x4DE0, 0x4EE0, 0x4FE0
	WORD 0x5000, 0x5100, 0x5200, 0x5300, 0x5400, 0x5500, 0x5600, 0x5700
	WORD 0x5020, 0x5120, 0x5220, 0x5320, 0x5420, 0x5520, 0x5620, 0x5720
	WORD 0x5040, 0x5140, 0x5240, 0x5340, 0x5440, 0x5540, 0x5640, 0x5740
	WORD 0x5060, 0x5160, 0x5260, 0x5360, 0x5460, 0x5560, 0x5660, 0x5760
	WORD 0x5080, 0x5180, 0x5280, 0x5380, 0x5480, 0x5580, 0x5680, 0x5780
	WORD 0x50A0, 0x51A0, 0x52A0, 0x53A0, 0x54A0, 0x55A0, 0x56A0, 0x57A0
	WORD 0x50C0, 0x51C0, 0x52C0, 0x53C0, 0x54C0, 0x55C0, 0x56C0, 0x57C0
	WORD 0x50E0, 0x51E0, 0x52E0, 0x53E0, 0x54E0, 0x55E0, 0x56E0, 0x57E0

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

draw_sprite:

._PARAM_COORDS:            EQU 18       ; Sprite coordinates
._PARAM_DIMS:              EQU 16       ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 14       ; Sprite pre-shifted data lookup table
._PARAM_MASK_DATA:         EQU 12       ; Mask pre-shifted data lookup table

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Point IX to the stack
    ADD IX,SP                           

    ; Initialize the collision flag
    LD HL,collided                      ; Flag the collision
    LD (HL),0x00

    ; Get and store the coords
    LD HL,(IX+._PARAM_COORDS)           ; Grab the pixel coords
    LD (._coords),HL                    ; And store for later (only the Y coord gets updated)

    ; Get and store the dimensions
    LD HL,(IX+._PARAM_DIMS)             ; Grab dimension data (X in characters, Y in pixel lines)
    LD (._dims),HL                      ; And store for later

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+._PARAM_SPRITE_DATA)      ; Start of sprite lookup table
    LD A,(._x_coord)                    ; X coord
    AND 0b00000111                      ; Calculate the X offset withing the character cell
    SLA A                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                           ; Add the offset into the table to the base of the table
    LD DE, (HL)                         ; Lookup the sprite data in the table
    LD (._sprite_data_ptr), DE          ; Points to sprite data
     
    ; Find the correct shifted version of the mask data
    LD HL,(IX+._PARAM_MASK_DATA)        ; Start of mask lookup table
    LD A,(._x_coord)                    ; X coord
    AND 0b00000111                      ; Calculate the X offset withing the character cell
    SLA A                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                           ; Add the offset into the table to the base of the table
    LD DE, (HL)                         ; Lookup the sprite data in the table
    LD (._mask_data_ptr), DE            ; Points to mask data

    LD A,(._y_dim)                      ; Y loop counter set from y dimension
    LD C,A

.ds_y_loop:   
    LD HL,(._coords)                    ; Current screen coords
    PUSH HL 
    PUSH HL                             ; Space for the return value
    CALL coords_to_mem                  ; Get Memory location of screen byte into HL
    POP HL
    LD (._screen_mem_loc),HL            ; Store the start of the row in screen memory
    POP HL

    LD A,(._x_dim)                      ; X dim loop counter - character cells
    LD B,A

.ds_x_loop:
    ; Collision check
    LD HL,(._sprite_data_ptr)           ; Get sprite data
    LD A,(HL)                                     
    LD HL,(._screen_mem_loc)            ; Get screen byte
    AND (HL)                            ; And sprite data with screen byte
    JR Z,.no_collision
    LD HL,collided                      ; Flag the collision
    LD (HL),0x01

.no_collision
    ; Draw mask -->
    LD HL,(._mask_data_ptr)             ; Get the mask data
    LD A,(HL)                                  
    CPL                                 ; Compliment the mask
    LD HL,(._screen_mem_loc)            ; Get screen byte
    AND (HL)                            ; And notted mask with screen byte
    LD (HL),A                           ; Write screen memory
  
    ; Done writing mask data, move pointer on for next iteration                     
    LD HL,(._mask_data_ptr)             ; Move to next byte of mask data
    INC HL
    LD (._mask_data_ptr),HL
    ; <-- End of draw mask

    ; Draw sprite -->
    LD HL,(._sprite_data_ptr)           ; Get sprite data
    LD A,(HL)                                     
    LD HL,(._screen_mem_loc)            ; Get screen byte
    XOR (HL)                            ; Or sprite data with screen byte
    LD (HL),A                           ; Write screen memory

    ; Done writing sprite data, move pointer on for next iteration                                 
    LD HL,(._sprite_data_ptr)           ; Move to next byte of sprite data
    INC HL
    LD (._sprite_data_ptr),HL
    ; <-- End of draw sprite

    ; Done writing current byte of current row - move to next X cell 
    LD HL,(._screen_mem_loc)            ; Move to next X cell
    INC HL              
    LD (._screen_mem_loc), HL
    
    ; Are we done writing this pixel row?
    DEC B                               ; Decrease the X loop counter
    JR NZ,.ds_x_loop                    ; Next X

    ; Move to next pixel row   
    LD HL,(._coords)                    ; Next pixel row
    INC HL                              
    LD (._coords), HL
    
    ; Is there another pixel row to write?
    DEC C                               ; Y loop counter
    JP NZ,.ds_y_loop

    POP IX,HL,DE,BC,AF   

    RET

._coords:                               ; Sprite location (y is updated to line being drawn)
._y_coord:         BLOCK 1
._x_coord:         BLOCK 1
._dims:                                 ; Sprite dimensions
._y_dim:           BLOCK 1
._x_dim:           BLOCK 1
._sprite_data_ptr  BLOCK 2              ; Pointer to current sprite data byte
._mask_data_ptr    BLOCK 2              ; Pointer to current mask data byte
._screen_mem_loc:  BLOCK 2              ; Pointer to current screen byte

    ENDMODULE

   

    