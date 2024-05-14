init:
    RET

; Collision detection
collided:           BLOCK 1                             ; The last draw operation detected a collision
collision_coords:
collision_y:        BLOCK 1
collision_x:        BLOCK 1

;------------------------------------------------------------------------------
;
; Set the colour of the screen border
;
; Usage:
;   PUSH rr          ; Colour in LSB
;   CALL set_border
;   POP rr           ; Ditch the supplied parameter
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

set_border:

.PARAM_BORDER_COLOUR:  EQU 8

    PUSH AF,HL,IX
    
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_BORDER_COLOUR)

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
    LD HL,0x0000                                        ; Fill with zero values (blank)
    PUSH HL
    LD HL,memory_map.SCREEN_START                             ; Start of screen area
    PUSH HL
    LD HL, memory_map.SCREEN_SIZE                             ; Length of screen area
    PUSH HL
    CALL utils.fill_mem                                 ; Erase the screen
    POP HL                                              ; Ditch the supplied parameters
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

.PARAM_ATTRIBUTE: EQU 6                                 ; Colour attributes

    PUSH HL,IX   

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    ; Set up call to utils.fill_mem
    LD HL, (ix+.PARAM_ATTRIBUTE)                        ; Get the colour attribute
    PUSH HL                             
    LD HL,memory_map.SCREEN_ATTR_START                        ; Start of the screen attribute area
    PUSH HL
    LD HL,memory_map.SCREEN_ATTR_SIZE                         ; Length of the screen attribute area
    PUSH HL
    CALL utils.fill_mem                                 ; Fill the screen attribute area
    POP HL                                              ; Ditch the supplied parameters
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

.PARAM_TOP_LEFT:          EQU 16
.PARAM_DIM:               EQU 14
.PARAM_ATTRIBUTE:         EQU 12

    PUSH AF,BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+.PARAM_ATTRIBUTE)                         ; Get the colour attribute
    LD A,L
    LD (.attribute),A

    LD HL,(IX+.PARAM_TOP_LEFT)                          ; Top left of rect to fill
    LD (.top_left),HL

    LD HL,(IX+.PARAM_DIM)                               ; Width and hight of rect to fill
    LD (.dim),HL

    ; Calculate the starting address
    LD DE, memory_map.SCREEN_ATTR_START                ; Base address of attribute map
    LD A,(.x)                                          ; Set low order byte from x coord
    LD E,A 
    
    LD H,0x00                                          ; Take Y coord
    LD A,(.y)                                          ; Multiple x32
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
    ADD DE,HL                                           ; DE will track memory to write                       

    ; Calculate line step bytes
    LD A,(.dim_width)                                  ; Subtract the width of the block 
    LD B,A                                              ; from bytes in a line
    LD A, SCREEN_WIDTH_CHARS
    SUB B
    LD (.line_step_bytes),A                            ; Store away line step update
    
    LD A,(.dim_height)                                 ; Set y loop counter (B) from height
    LD B,A

.y_loop:
    LD A,(.dim_width)                                  ; Set x loop counter (C) from width
    LD C,A

._x_loop:
    LD A, (.attribute)                                 ; Get the screen attribute
    LD (DE),A                                           ; Store at current screen map location
    INC DE                                              ; Move to next screen map location

    DEC C                                               ; Any more to do in this line?
    JR NZ,._x_loop                   

    LD H,0x00                                           ; Move to next line
    LD A,(.line_step_bytes)
    LD L,A
    ADD DE,HL

    DEC B                                               ; Any more lines to do?
    JR NZ,.y_loop

    POP IX,HL,DE,BC,AF

    RET

.top_left:  
.y:                 BLOCK 1
.x:                 BLOCK 1
.dim:
.dim_height:        BLOCK 1
.dim_width:         BLOCK 1
.attribute:         BLOCK 1
.line_step_bytes:   BLOCK 1

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

.PARAM_Y:      EQU 12
.PARAM_ATTR:   EQU 10

    PUSH BC,DE,HL,IX

    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD HL, (IX+.PARAM_Y)                                ; H = Y coord, L = height
    LD BC, (IX+.PARAM_ATTR)                             ; C = Attribute   

    ; XY Coords
    LD D,0x00;                                          ; X=0
    LD E,H                                              ; Y as supplied
    PUSH DE

    ; XY Dimensions
    LD D,SCREEN_WIDTH_CHARS                             ; X dimension full screen width
    LD E,L                                              ; Y dimension as supplied
    PUSH DE

    PUSH BC                                             ; Colour attribute

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

.PARAM_COORDS:   EQU 12                                 ; Coordinates
.RTN_MEM:        EQU 10                                 ; Memory location return value

    PUSH AF,BC,HL,IX
   
    LD  IX,0                                            ; Get the stack pointer
    ADD IX,SP

    LD BC, (IX+.PARAM_COORDS)                           ; Get coords from the stack
    LD B, 0x00                                          ; B=0x00, C=Y coord
    SLA C                                               ; Double Y to get offset in table (as table contains words)
    RL B
    LD HL, draw_common._Y_MEM_ROW_LOOKUP                ; Base of lookup table in HL
    ADD HL,BC                                           ; Location of the row start in the lookup table
    LD BC,(HL)                                          ; Location of row start
    LD HL,BC                                            ; Move result into HL

    ; Calculate X7,X6,X5,X4,X3
    LD BC, (IX+.PARAM_COORDS)                           ; Get coords from the stack
    LD A,B                                              ; Grab the x coord
    SRL A                                               ; Shift into position
    SRL A
    SRL A
    OR L                                                ; OR with Y5,Y4,Y3
    LD L,A                                              ; Store in L
  
    LD (IX+.RTN_MEM),HL                                 ; Put the return value on the stack

    POP IX,HL,BC,AF

    RET