;------------------------------------------------------------------------------
;
; Erase current alien
; 
; Usage:
;
;   CALL draw_alien
;
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

blank_alien:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    LD A,(IX+_STATE_OFFSET_STATE)
    ; BIT _ALIEN_STATE_DIEING_BIT,A
    ; JR NZ,.blank_explosion

    ; Is the current alien dead or new
    AND _ALIEN_STATE_DEAD | _ALIEN_STATE_NEW,A
    JR NZ,.done                                         ; Dead or new so nothing to do

    ; Blank old sprite position
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite and mask based on variant
    LD A,(IX+_STATE_OFFSET_VARIANT)        
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IX+_STATE_OFFSET_VAR_0_BLANK)                
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IX+_STATE_OFFSET_VAR_1_BLANK)                

.variant_selected:
    PUSH HL                                             ; Sprite/mask is in HL

    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

.done

    POP IX,HL,DE,AF

    RET

;------------------------------------------------------------------------------
;
; Draw current alien
; 
; Usage:
;
;   CALL draw_alien
;
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

draw_current_alien:
    PUSH AF,DE,HL,IX
    
     ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    ; Is the deferred alien active pr new
    LD A,(IX+_STATE_OFFSET_STATE)
    AND _ALIEN_STATE_ACTIVE|_ALIEN_STATE_NEW,A    
    JR Z,.done                                          ; Dead 

    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    ; Select sprite and mask based on variant
    LD A,(_current_pack_variant_flag)                          
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         

    ; Using variant 0                         
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)
    PUSH HL 

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_0 
    JR .variant_selected

.variant_1_is_current:   
    ; Using variant 1
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE) 
    PUSH HL

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_1

.variant_selected:
    CALL fast_draw.fast_draw_sprite_16x8

    POP DE
    POP DE

.done:
    POP IX,HL,DE,AF

    RET
