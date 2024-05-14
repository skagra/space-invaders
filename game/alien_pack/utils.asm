get_alien_at_coords:

.PARAM_COORDS: EQU 16                                   ; Coords to look for alien
.RTN_ALIEN_PTR: EQU 14                                  ; Return value

    PUSH AF,BC,DE,HL,IX,IY

    ; Point IY to the stack
    LD  IY,0                                            
    ADD IY,SP   

    ; Flag hit not found
    LD (IY+.RTN_ALIEN_PTR), 0xFF                       
    LD (IY+.RTN_ALIEN_PTR+1), 0xFF

    ; Index of current alien
    LD A,0x00                                           
    LD (.alien_index),A

    ; Get the target coordinates and store for later
    LD HL,(IY+.PARAM_COORDS);
    LD (.target_coords),HL

    ; LOGPOINT [COLLISION] get_alien_at_coords: Target coords X=${H} Y=${L}

    ; Initialize pointer to scan through alien lookup table
    LD HL,_ALIEN_LOOKUP                                   
    LD (.alien_lookup_trace), HL                        

.y_loop
    ; Get current alien state
    LD HL,(.alien_lookup_trace)                         ; Get location in alien lookup table
    LD DE,(HL)                                          ; Dereference to get pointer to alien state
    LD IX,DE                                            ; Set IX to point to alien state

    ; Is the alien active?
    LD A,(IX+alien_pack._STATE_OFFSET_STATE);           ; Is alien active?
    BIT alien_pack._ALIEN_STATE_ACTIVE_BIT,A
    JR Z,.row_not_found                                 ; No - so skip it

    IFDEF DEBUG
        LD B,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)
        ; LOGPOINT [COLLISION] get_alien_at_coords: Testing top at ${B}
    ENDIF

    ; Is the target Y "below" to top of the alien - Y coords increase as we go down the screen
    LD A,(.target_y)                                    ; Y coord of collision
    CP (IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)      ; Compare to top of alien
    JR C,.row_not_found                                 ; Is the top of the alien coord greater than the target coord

    ; Is the target Y "above" the bottom of the alien?
    LD A,(.target_y)
    LD B,A
    LD A,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_Y)
    ADD 0x08                                            ; Bottom of alien is at +8

    ; LOGPOINT [COLLISION] get_alien_at_coords: Testing bottom at ${A}

    CP B
    JR C,.row_not_found                                 ; Bottom of alien > target_y => not found

    ; LOGPOINT [COLLISION] get_alien_at_coords: Row match at index ${b@(alien_pack.get_alien_at_coords.alien_index)}

    JR .x_loop                                          ; We have found the correct row - now search for the correct column

.row_not_found:
    ; LOGPOINT [COLLISION] get_alien_at_coords: Not a row match

    ; Have we at the end of the list of aliens?
    LD A,(.alien_index)
    INC A
    CP _ALIEN_PACK_SIZE
    JR Z, .not_found
    LD (.alien_index),A

    ; Skip to next alien 
    LD HL,(.alien_lookup_trace)                        
    INC HL
    INC HL
    LD (.alien_lookup_trace),HL

    JR .y_loop                                          ; Try the next column

.x_loop:
    LD HL,(.alien_lookup_trace)                         ; Get location in alien lookup table
    LD DE,(HL)                                          ; Dereference to get pointer to alien state
    LD IX,DE                                            ; Point IX to alien state

    ; Is the alien active?
    LD A,(IX+alien_pack._STATE_OFFSET_STATE);           ; Is the alien active?
    BIT alien_pack._ALIEN_STATE_ACTIVE_BIT,A
    JR Z,.col_not_found                                 ; No - so skip it
   
    ; Is the target X <= alien RHS
    LD A,(.target_x)
    LD A,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)    ; Alien X coord
    ADD 14                                              ; RHS of alien is at +16  TODO
    LD B,A
    LD A,(.target_x)
    ; LOGPOINT [COLLISION] get_alien_at_coords: Testing RHS=${B}
    CP B                                                ; Compare alien RHS with target X
    JR NC,.col_not_found                                ; If target X is greater than alien RHS move to next

    ; Is the target X >= alien LHS
    IFDEF DEBUG
        LD B,(IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)
        ; LOGPOINT [COLLISION] get_alien_at_coords: Testing LHS at ${B}
    ENDIF
    LD A,(.target_x)
    INC A
    INC A
    CP (IX+alien_pack._STATE_OFFSET_DRAW_COORDS_X)                                              
    JR C,.col_not_found                                 ; No, so not this alien.  TODO Can we jump right to done here?

    ; Alien found
    ; LOGPOINT [COLLISION] get_alien_at_coords: Match found at index ${b@(alien_pack.get_alien_at_coords.alien_index)}

    ; Set the return value
    LD HL,(.alien_lookup_trace)                         
    LD DE,(HL)
    LD (IY+.RTN_ALIEN_PTR),E
    LD (IY+.RTN_ALIEN_PTR+1),D

    JR .done

.col_not_found:                                         ; Target column not found
    ; Are we at end of pack?
    LD A,(.alien_index)
    INC A
    CP _ALIEN_PACK_SIZE
    JR Z,.not_found
    LD (.alien_index),A

    LD HL,(.alien_lookup_trace)                         ; Move to next alien in lookup table
    INC HL
    INC HL
    LD (.alien_lookup_trace),HL
    JR .x_loop                                          ; Next alien

.not_found:
    ; LOGPOINT [COLLISION] get_alien_at_coords: Match NOT found
    NOP 

.done
    POP IY,IX,HL,DE,BC,AF

    RET

.alien_lookup_trace:    WORD 1
.target_coords:
.target_y:              BYTE 1
.target_x:              BYTE 1
.alien_index:           BYTE 1