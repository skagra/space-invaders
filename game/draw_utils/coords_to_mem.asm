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
;   PUSH rr                             ; Coords word X MSB Y LSB
;   PUSH rr                             ; Space for return value
;   CALL coords_to_mem
;   POP rr                              ; Return value memory location
;   POP rr
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
    LD HL,Y_MEM_ROW_LOOKUP                              ; Base of lookup table in HL
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
  
    IFDEF DIRECT_DRAW
        RES 7,H
    ENDIF
    LD (IX+.RTN_MEM),HL                                 ; Put the return value on the stack

    POP IX,HL,BC,AF

    RET
