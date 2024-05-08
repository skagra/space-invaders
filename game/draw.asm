    MODULE draw

    INCLUDE "y_mem_row_lookup.asm"

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
    
    LD H,0x00                           ; Take Y coord
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
    LD HL, _Y_MEM_ROW_LOOKUP              ; Base of lookup table in HL
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

; _Y_LOOKUP_TABLE:
; 	WORD 0xC000, 0xC100, 0xC200, 0xC300, 0xC400, 0xC500, 0xC600, 0xC700
; 	WORD 0xC020, 0xC120, 0xC220, 0xC320, 0xC420, 0xC520, 0xC620, 0xC720
; 	WORD 0xC040, 0xC140, 0xC240, 0xC340, 0xC440, 0xC540, 0xC640, 0xC740
; 	WORD 0xC060, 0xC160, 0xC260, 0xC360, 0xC460, 0xC560, 0xC660, 0xC760
; 	WORD 0xC080, 0xC180, 0xC280, 0xC380, 0xC480, 0xC580, 0xC680, 0xC780
; 	WORD 0xC0A0, 0xC1A0, 0xC2A0, 0xC3A0, 0xC4A0, 0xC5A0, 0xC6A0, 0xC7A0
; 	WORD 0xC0C0, 0xC1C0, 0xC2C0, 0xC3C0, 0xC4C0, 0xC5C0, 0xC6C0, 0xC7C0
; 	WORD 0xC0E0, 0xC1E0, 0xC2E0, 0xC3E0, 0xC4E0, 0xC5E0, 0xC6E0, 0xC7E0

; 	WORD 0xC800, 0xC900, 0xCA00, 0xCB00, 0xCC00, 0xCD00, 0xCE00, 0xCF00
; 	WORD 0xC820, 0xC920, 0xCA20, 0xCB20, 0xCC20, 0xCD20, 0xCE20, 0xCF20
; 	WORD 0xC840, 0xC940, 0xCA40, 0xCB40, 0xCC40, 0xCD40, 0xCE40, 0xCF40
; 	WORD 0xC860, 0xC960, 0xCA60, 0xCB60, 0xCC60, 0xCD60, 0xCE60, 0xCF60
; 	WORD 0xC880, 0xC980, 0xCA80, 0xCB80, 0xCC80, 0xCD80, 0xCE80, 0xCF80
; 	WORD 0xC8A0, 0xC9A0, 0xCAA0, 0xCBA0, 0xCCA0, 0xCDA0, 0xCEA0, 0xCFA0
; 	WORD 0xC8C0, 0xC9C0, 0xCAC0, 0xCBC0, 0xCCC0, 0xCDC0, 0xCEC0, 0xCFC0
; 	WORD 0xC8E0, 0xC9E0, 0xCAE0, 0xCBE0, 0xCCE0, 0xCDE0, 0xCEE0, 0xCFE0

; 	WORD 0xD000, 0xD100, 0xD200, 0xD300, 0xD400, 0xD500, 0xD600, 0xD700
; 	WORD 0xD020, 0xD120, 0xD220, 0xD320, 0xD420, 0xD520, 0xD620, 0xD720
; 	WORD 0xD040, 0xD140, 0xD240, 0xD340, 0xD440, 0xD540, 0xD640, 0xD740
; 	WORD 0xD060, 0xD160, 0xD260, 0xD360, 0xD460, 0xD560, 0xD660, 0xD760
; 	WORD 0xD080, 0xD180, 0xD280, 0xD380, 0xD480, 0xD580, 0xD680, 0xD780
; 	WORD 0xD0A0, 0xD1A0, 0xD2A0, 0xD3A0, 0xD4A0, 0xD5A0, 0xD6A0, 0xD7A0
; 	WORD 0xD0C0, 0xD1C0, 0xD2C0, 0xD3C0, 0xD4C0, 0xD5C0, 0xD6C0, 0xD7C0
; 	WORD 0xD0E0, 0xD1E0, 0xD2E0, 0xD3E0, 0xD4E0, 0xD5E0, 0xD6E0, 0xD7E0

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

._PARAM_COORDS:            EQU 16       ; Sprite coordinates
._PARAM_DIMS:              EQU 14       ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 12       ; Sprite pre-shifted data lookup table
    
    PUSH AF,BC,DE,HL,IX

    LD  IX,0                            ; Point IX to the stack
    ADD IX,SP                                                   

    ; Initialize the collision flag
    LD HL,collided                      
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
    AND 0b00000111                      ; Calculate the X offset within the character cell
    SLA A                               ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                           ; Add the offset into the table to the base of the table
    LD DE, (HL)                         ; Lookup the sprite data in the table
    LD (._sprite_data_ptr),DE           ; Points to sprite data
   
    LD A,(._y_dim)                      ; Y loop counter set from Y dimension
    LD C,A

    ; Calculate screen memory location to start drawing at
    LD HL,(._coords)                    ; Current screen coords
    PUSH HL 
    PUSH HL                             ; Space for the return value
    CALL coords_to_mem                  ; Get Memory location of screen byte into HL
    POP HL
    LD (._screen_mem_loc_trace),HL      ; Store the start of the row in screen memory
    LD (._row_first_mem_lock),HL
    POP HL

.ds_y_loop:
    LD A,(._x_dim)                      ; X dim loop counter - character cells
    LD B,A

.ds_x_loop:
    LD HL,(._screen_mem_loc_trace)      ; Get screen byte location
    LD DE,(._sprite_data_ptr)           ; Pointer to sprite and mask data 

    ; Collision detection
    LD A,(DE)                           ; Mask data - TODO using mask for collision detection is not ideal 
    CPL                                 ; Invert mask
    AND (HL)                            ; And corresponding bits on screen set?
    JR Z,.no_collision                  ; No - so no collision
    LD A,0x01                           ; Flag the collision
    LD (collided),A

.no_collision
    ; Drawing
    LD A,(DE)                           ; Get the mask data                              
    AND (HL)                            ; And the mask with the screen byte
    LD (HL),A                           ; Write screen memory

    INC DE                              ; Sprite data is next

    LD A,(DE)                           ; Get the sprite data
    OR (HL)                             ; Or the sprite data with the screen byte
    LD (HL),A                           ; Write to screen memory

    INC DE                              ; Move to next byte of mask/sprite data
    LD (._sprite_data_ptr),DE

    ; We have written to the offscreen buffer - so record what we have done
    LD DE,HL                                            ; Copy address written to in buffer
    LD HL,(double_buffer._buffer_stack_top)             ; Top of stack address                                         
    LD (HL),DE                                          ; Write screen buffer address at top of stack            
    INC HL                                              ; Increase the stack top pointer +2 as a word was written
    INC HL
    LD (double_buffer._buffer_stack_top),HL

    ; Done writing current byte of current row - move to next X cell  
    LD HL,(._screen_mem_loc_trace)
    INC HL                              
    LD (._screen_mem_loc_trace),HL
    
    CHECK_STACK_OVERFLOW

    ; Are we done writing this pixel row?
    DEC B                               ; Decrease the X loop counter
    JR NZ,.ds_x_loop                    ; Next X

    ; Move to next pixel row   
    LD A,(._y_coord)
    INC A
    LD (._y_coord),A
    
    ; Is there another pixel row to write?
    DEC C                               ; Y loop counter
    JP Z,.done

    ; Caculate subsequent mem locations based on offset,
    ; this is faster than calling coords_to_mem each time.

    ; Easy case is when we are not at end of a block of 8
    LD A,(._y_coord)                    ; New Y divisible by 8?
    AND 0b00000111                      
    JR Z,.block_8                       ; Yes

    ; Not at end of block of 8 rows, next row is at + 0x0100
    LD HL,(._row_first_mem_lock)
    LD DE,0x0100
    ADD HL,DE
    LD (._row_first_mem_lock), HL
    LD (._screen_mem_loc_trace),HL

    JR .ds_y_loop

.block_8:
    LD A,(._y_coord)                    ; New Y divisible by 64?
    AND 0b00111111
    JR Z,.block_64                      ; Yes

    ; Not at the end of a block of 64 rows, next row is at -0x06E0
    LD HL,(._row_first_mem_lock)
    LD DE,0x06E0
    SUB HL,DE
    LD (._row_first_mem_lock), HL
    LD (._screen_mem_loc_trace),HL

    JR .ds_y_loop

.block_64:
    ; Next row is at +0x0020
    LD HL,(._row_first_mem_lock)
    LD DE,0x0020
    ADD HL,DE
    LD (._row_first_mem_lock), HL
    LD (._screen_mem_loc_trace),HL

    JP .ds_y_loop

.done
    POP IX,HL,DE,BC,AF   

    RET

._coords:                               ; Sprite location (Y is updated to line being drawn)
._y_coord:              BLOCK 1
._x_coord:              BLOCK 1
._dims:                                 ; Sprite dimensions
._y_dim:                BLOCK 1
._x_dim:                BLOCK 1
._sprite_data_ptr       BLOCK 2         ; Pointer to current sprite data byte
._screen_mem_loc_trace: BLOCK 2         ; Pointer to current screen byte
._row_first_mem_lock:   BLOCK 2         ; Point to screen byte first drawn on current row

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
        LD HL,BC                                            ; Buffer address
        LD DE,(HL)                                          
        LD A,(._x_offset_stash)                             ; Merge in x offset
        OR E
        LD E,A

        ; Record that we are writing to the double buffer
        LD HL,(double_buffer._fast_buffer_stack_top)             ; Top of stack address        
        LD (HL),DE                                          ; Write screen buffer address at top of stack            
        INC HL                                              ; Increase the stack top pointer +2 as a word was written
        INC HL
        LD (double_buffer._fast_buffer_stack_top),HL

        ; First word of mask/data
        POP HL                                              ; Mask and sprite data
        LD A,(DE)                                           ; Data from screen
        AND L
        OR H
        LD (DE),A

        ; Second word of mask/data
        INC DE
        POP HL                                              ; Mask and sprite data
        LD A,(DE)                                           ; Data from screen
        AND L
        OR H
        LD (DE),A

        ; Third word of mask/data
        INC DE
        POP HL                                              ; Mask and sprite data
        LD A,(DE)                                           ; Data from screen
        AND L
        OR H
        LD (DE),A

        NOP                                                 ; Space self modified code
        NOP                                                 ; JP ._back
        NOP

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

._PARAM_COORDS:            EQU 14               ; Sprite coordinates
._PARAM_SPRITE_DATA:       EQU 12               ; Sprite pre-shifted data lookup table
    
    DI                                          ; Disable interrupts as we'll be messing with the SP

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                    ; Point IX to the stack
    ADD IX,SP                                                   

    ; Initialize the collision flag
    LD HL,collided                      
    LD (HL),0x00

    ; Get and store the coords
    LD HL,(IX+._PARAM_COORDS)                   ; Grab the pixel coords
    LD (._coords),HL                            ; And store for later (only the Y coord gets updated)

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+._PARAM_SPRITE_DATA)              ; Start of sprite lookup table
    LD A,(._x_coord)                            ; X coord
    AND 0b00000111                              ; Calculate the X offset within the character cell
    SLA A                                       ; Double the offset as the lookup table contains words
    LD D,0x00
    LD E,A
    ADD HL,DE                                   ; Add the offset into the table to the base of the table                 
    LD DE, (HL)                                 ; Lookup the sprite data ptr in the table

    ; Calculate X7,X6,X5,X4,X3
    LD A,(._x_coord)                            ; Grab the x coord
    SRL A                                       ; Shift into position
    SRL A
    SRL A
    LD (._x_offset_stash),A

    ; Find the start of the group of entries in the Y lookup table
    LD B, 0x00                                  ; B=0x00, C=Y coord
    LD A,(._y_coord)
    LD C,A
    SLA C                                       ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, _Y_MEM_ROW_LOOKUP                      ; Base of lookup table in HL
    ADD HL,BC                                   ; Location of the row start in the lookup table
    LD BC,HL

    LD (._stack_stash),SP                       ; Store current SP to restore at end
    LD HL,DE
    LD SP,HL

    ; Render row 0 (top most)
    RENDER_ROW 

    ; Render row 1
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 
    
    ; Render row 2
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 3
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 4
    INC BC                                      ; Next entry in Y lookup table  
    INC BC
    RENDER_ROW 

    ; Render row 5
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 6
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 

    ; Render row 7 (bottom most)
    INC BC                                      ; Next entry in Y lookup table
    INC BC
    RENDER_ROW 
    
    LD SP,(._stack_stash)                       ; Restore the original SP

    POP IX,HL,DE,BC,AF   

    EI
    
    RET

._coords:                                       ; Sprite coords
._y_coord:              BLOCK 1
._x_coord:              BLOCK 1
._stack_stash:          BLOCK 2                 ; Safe store for stack pointer
._address_to_call:      BLOCK 2                 ; Address in the unrolled loop of RENDER_ROW to call
._modified_code:        BLOCK 2                 ; Address to insider JP ._back self modifed code
._x_offset_stash:       BLOCK 1

    ENDMODULE

   

    