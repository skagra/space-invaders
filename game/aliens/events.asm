event_alien_hit_by_player_missile:

.PARAM_ALIEN_STATE_PTR EQU 8 

    PUSH HL,IX,IY

    ; Point IX to the stack
    LD  IX,0                                            
    ADD IX,SP   

    ; Pointer to the collided alien
    LD HL,(IX+.PARAM_ALIEN_STATE_PTR)

    ; Store it
    LD (_exploding_alien),HL

    ; Halt the pack during the explosion
    LD A,utils.TRUE_VALUE
    LD (_pack_halted),A

    ; Set the alien state to be dead
    LD IY,HL
    LD (IY+aliens._STATE_OFFSET_STATE),_ALIEN_STATE_DEAD_VALUE 

    ; Blank out the alien
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL     

    ; Select sprite mask based on variant
    LD A,(IY+_STATE_OFFSET_VARIANT)                     
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IY+_STATE_OFFSET_VAR_0_SPRITE)               ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IY+_STATE_OFFSET_VAR_1_SPRITE)               ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    LD L,utils.TRUE_VALUE                               ; Blanking
    PUSH HL
    
    CALL fast_draw.draw_sprite_16x8
    
    POP DE 
    POP DE
    POP DE

    ; Draw alien explosion
    LD HL,(IY+_STATE_OFFSET_DRAW_COORDS)                ; Coords
    PUSH HL  

    LD HL,sprites.ALIEN_EXPLOSION;                      ; Sprite
    PUSH HL

    LD L,utils.FALSE_VALUE                              ; Drawing
    PUSH HL 

    CALL fast_draw.draw_sprite_16x8

    POP HL 
    POP HL
    POP HL

    POP IY,IX,HL

    ; Decrease the count of aliens
    LD A,(_alien_count)
    DEC A
    LD (_alien_count),A

    ; Are we down to the last alien?

    RET

.EXPLODING_ALIEN_DELAY EQU  15