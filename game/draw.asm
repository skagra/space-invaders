    MODULE draw

_module_start:

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

_BUFFER_STACK: BLOCK 512   
_buffer_stack_top:  BLOCK 2                             ; This points to the next free location on the stack

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
; Draw a sprite and flush the double buffer to the screen
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

draw_sprite_and_flush_buffer:

._PARAM_COORDS:            EQU 10                       ; Sprite coordinates
._PARAM_DIMS:              EQU 8                        ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 6                        ; Sprite pre-shifted data lookup table
    
    PUSH HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   

    LD HL,(IX+._PARAM_COORDS)
    PUSH HL
    LD HL,(IX+._PARAM_DIMS)
    PUSH HL
    LD HL,(IX+._PARAM_SPRITE_DATA)
    PUSH HL

    CALL draw.draw_sprite

    POP HL
    POP HL
    POP HL

    CALL copy_buffer_to_screen

    POP IX,HL

    RET

copy_buffer_to_screen:
    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (._stack_stash),SP                               ; Store current SP to restore at end

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
    
    LD SP,(._stack_stash)                               ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

._stack_stash: BLOCK 2

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
    LD HL, draw_common._Y_MEM_ROW_LOOKUP ; Base of lookup table in HL
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

._PARAM_COORDS:            EQU 16                       ; Sprite coordinates
._PARAM_DIMS:              EQU 14                       ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 12                       ; Sprite pre-shifted data lookup table
    
    DI 

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP                                                   

    ; Initialize the collision flag
    LD HL,draw_common.collided                      
    LD (HL),0x00

    ; Get and store the coords
    LD HL,(IX+._PARAM_COORDS)                           ; Grab the pixel coords
    LD (.coords),HL                                     ; And store for later (only the Y coord gets updated)

    ; Get and store the dimensions
    LD HL,(IX+._PARAM_DIMS)                             ; Grab dimension data (X in characters, Y in pixel lines)
    LD (.dims),HL                                       ; And store for later

    ; Find the correct shifted version of the sprite data
    LD HL,(IX+._PARAM_SPRITE_DATA)                      ; Start of sprite lookup table
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
        call copy_buffer_to_screen
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

    MEMORY_USAGE "draw            ",_module_start
    
    ENDMODULE

   

    