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
    LD A,B                              ; Calculate X4,X3,X2,X1,X0
    RRA                                 ; Shift into position
    RRA
    RRA
    AND 0b00011111                      ; Mask out unwanted bits
    OR L                                ; OR with Y5,Y4,Y3
    LD L,A                              ; Store in L

    POP IX,BC,AF
    RET

;-----------------------------------------------------------
; Shift sprite data right and merge in previous overspill
;-----------------------------------------------------------

SHIFT_N_PARAM_STEPS:        EQU 6
SHIFT_N_VALUE:              EQU 7
SHIFT_N_OLD_VALUE:          EQU 9

shift_n_and_merge:
    PUSH BC,IX
    LD  IX,0
    ADD IX,SP                           ; Point IX to the stack
  
    LD B, (IX+SHIFT_N_PARAM_STEPS)      ; Loop counter

    LD L, 0x00                          ; HL holds result
    LD H, (IX+SHIFT_N_VALUE)            ; Value to shift
sn_loop:
    LD A,B
    CP 0x00
    JR Z,sn_endloop 
    SRL H                               ; Shift out low bit into carry
    RR L 
    DEC B
    JR sn_loop
sn_endloop:
    LD A,H                              ; Now shifted high byte
    OR (IX+SHIFT_N_OLD_VALUE)           ; Merge in old value
    LD H,A
    
    POP IX,BC
    RET  

;------------------------------------------------
; Draw a sprite
;
; PUSH coords
; PUSH sprite data location
; PUSH mask location (NOT used currently)
;------------------------------------------------

DS_PARAM_COORDS:            EQU 16
DS_PARAM_SPRITE_DATA:       EQU 14
DS_PARAM_MASK:              EQU 12

draw_sprite:
    PUSH AF,BC,DE,HL,IX

    LD  IX,0
    ADD IX,SP                           ; Point IX to the stack

    LD HL,(IX+DS_PARAM_SPRITE_DATA)     ; Start of sprite data
    LD BC,(HL)                          ; Grab dimension data (X in characters, Y in pixel lines)
    LD (ds_dims),BC                     ; And store for later

    INC HL                              ; Skip to bitmap data
    INC HL

    LD (ds_sprite_data_ptr), HL         ; Points to sprite data
                                
    LD HL,(IX+DS_PARAM_COORDS)          ; Grab the pixel coords
    LD (ds_coords),HL                   ; And store for later (only the Y coord gets updated)

    LD A,(ds_y_dim)                     ; Y dim loop counter - pixel lines
    LD C,A

    LD A,(ds_x_coord)                   ; X coord
    AND 0b00000111                      ; Calculate the X offset withing the character cell
    LD (ds_x_offset), A                 ; Store it away for later use

    LD HL,(IX+DS_PARAM_MASK)            ; Mask data
    LD (ds_mask_data_ptr),HL            ; Points to the mask data

ds_y_loop:   
    LD HL,(ds_coords)                   ; Current screen coords
    PUSH HL                 
    CALL coords_to_mem                  ; Get Memory location of screen byte into HL
    LD (ds_screen_mem_loc), HL          ; Store the start of the row in screen memory
    POP HL

    LD A,(ds_x_dim)                     ; X dim loop counter - character cells
    LD B,A

    LD HL,ds_x_spill                    ; Zero out rolling content from previous cell as we shift bitmap
    LD (HL),0x00

    LD HL,ds_x_mask_spill               ; Zero out rolling mask spill 
    LD (HL),0x00

ds_x_loop:
    ; Draw the mask

    LD A, (ds_x_mask_spill)             ; Push single byte of last X content onto the stack
    PUSH AF
    
    LD HL,(ds_mask_data_ptr)            ; Get mask data for current byte
    LD A,(HL)                           

    LD H,A                              ; X offset
    LD A,(ds_x_offset)                  
    LD L,A                     
    
    PUSH HL                             ; Push mask data and x offset 

    CALL shift_n_and_merge              ; HL containts the shifted data
    LD A,L
    LD (ds_x_mask_spill),A
              
    LD A,H                              ; Write mask data to the screen
    CPL 
    LD HL,(ds_screen_mem_loc)
    AND (HL)
    LD (HL),A   
    POP HL
    POP HL                            
                           
    LD HL,(ds_mask_data_ptr)            ; Move to next byte of mask data
    INC HL
    LD (ds_mask_data_ptr),HL

    ; End of draw mask

    ; Draw the sprite

    LD A, (ds_x_spill)                  ; Push single byte of last X content onto the stack
    PUSH AF
    
    LD HL,(ds_sprite_data_ptr)          ; Get sprite data for current byte
    LD A,(HL)                           

    LD H,A
    LD A,(ds_x_offset)                  ; X offset
    LD L,A                     
    
    PUSH HL

    CALL shift_n_and_merge              ; HL containts the shifted data
    LD A,L
    LD (ds_x_spill),A
              
    LD A,H                              ; Write sprite data to the screen
    LD HL,(ds_screen_mem_loc)
    OR (HL)
    LD (HL),A   
    POP HL
    POP HL                            
                           
    LD HL,(ds_sprite_data_ptr)          ; Move to next byte of sprite data
    INC HL
    LD (ds_sprite_data_ptr),HL

    ; End of drawing the sprite

    LD HL,(ds_screen_mem_loc)           ; Move to next X cell
    INC HL              
    LD (ds_screen_mem_loc), HL
    
    DEC B                               ; Decrease the X loop counter
    JR NZ,ds_x_loop                     ; Next X

    ; Draw the last shifted part of the mask
    LD A, (ds_x_mask_spill)
    CPL 
    LD HL,(ds_screen_mem_loc)
    AND (HL)
    LD (HL),A  

    ; Draw the last shifted part of the sprite
    LD A, (ds_x_spill)
    LD HL,(ds_screen_mem_loc) 
    OR (HL)
    LD (HL), A

    LD HL,(ds_coords)                   ; Next Y row
    INC HL                              
    LD (ds_coords), HL
    
    DEC C                               ; Y loop counter
    JP NZ,ds_y_loop

    POP IX,HL,DE,BC,AF   

    RET

; Sprite dimensions
ds_dims:
ds_y_dim:           BLOCK 1
ds_x_dim:           BLOCK 1
; Current sprint location (only y is updated)
ds_coords:  
ds_y_coord:         BLOCK 1
ds_x_coord:         BLOCK 1
; X offset within a character cell
ds_x_offset:        BLOCK 1
; Current location in screen memory map
ds_screen_mem_loc:  BLOCK 2
; Spill over from one character cell to the next after shifting data
ds_x_spill:         BLOCK 1
ds_x_mask_spill:    BLOCK 1
ds_sprite_data_ptr  BLOCK 2
ds_mask_data_ptr    BLOCK 2

    ENDMODULE

   

    