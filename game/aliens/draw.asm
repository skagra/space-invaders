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

blank:
    PUSH AF,DE,HL,IX

    ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    LD A,(IX+_STATE_OFFSET_STATE)                       ; State of current alien

    ; Is the current alien dead or new
    AND _ALIEN_STATE_DEAD_VALUE | _ALIEN_STATE_NEW_VALUE,A
    JR NZ,.done                                         ; Dead or new so nothing to do

    ; Blank old sprite position
    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite and mask based on variant
    LD A,(IX+_STATE_OFFSET_VARIANT)        
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)                
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE)                

.variant_selected:
    PUSH HL                                             ; Sprite/mask is in HL

    LD L,utils.TRUE_VALUE                               ; Blanking (not drawing)
    PUSH HL 
    
    CALL fast_draw.draw_sprite_16x8
    
    POP HL 
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

draw:
    PUSH AF,DE,HL,IX
    
     ; Point IX at the state structure for the current alien
    LD HL,(_current_alien_lookup_ptr)
    LD DE,(HL)
    LD IX,DE
    
    ; Do we need to draw the current alien?
    LD A,(IX+_STATE_OFFSET_STATE)
    AND _ALIEN_STATE_ACTIVE_VALUE|_ALIEN_STATE_NEW_VALUE,A    
    JR Z,.done                                          

    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    ; Select sprite and mask based on variant
    LD A,(_current_pack_variant_flag)                          
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         

    ; Using variant 0                         
    LD HL,(IX+_STATE_OFFSET_VAR_0_SPRITE)
    PUSH HL 

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_0_VALUE 
    JR .variant_selected

.variant_1_is_current:   
    ; Using variant 1
    LD HL,(IX+_STATE_OFFSET_VAR_1_SPRITE) 
    PUSH HL

    LD (IX+_STATE_OFFSET_VARIANT),_ALIEN_VARIANT_1_VALUE

.variant_selected:

    LD L,utils.FALSE_VALUE                              ; Drawing (not blanking)
    PUSH HL 
    
    CALL fast_draw.draw_sprite_16x8
    
    POP HL 
    POP DE
    POP DE

.done:
    POP IX,HL,DE,AF

    RET
