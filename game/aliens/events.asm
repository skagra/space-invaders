event_alien_hit_by_player_missile_begin:

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
    LD A,utils.FALSE_VALUE
    LD (_alien_pack_moving),A

    ; Flag that an alien is exploding
    LD A,utils.TRUE_VALUE
    LD (_alien_is_exploding),A

    ; Set the alien state to be dead
    LD IY,HL
    LD (IY+STATE_OFFSET_STATE),_ALIEN_STATE_DEAD_VALUE 

    ; Blank out the alien
    LD HL,(IY+STATE_OFFSET_DRAW_COORDS)                 ; Coords
    PUSH HL     

    ; Select sprite mask based on variant
    LD A,(IY+STATE_OFFSET_VARIANT)                     
    BIT _ALIEN_VARIANT_1_BIT,A
    JR NZ,.variant_1_is_current                         
                             
    LD HL,(IY+STATE_OFFSET_VAR_0_SPRITE)                ; Use sprite as mask 
    JR .variant_selected

.variant_1_is_current:   
    LD HL,(IY+STATE_OFFSET_VAR_1_SPRITE)                ; Use sprite as mask 

.variant_selected:
    PUSH HL                                             ; Mask is in HL

    LD L,utils.TRUE_VALUE                               ; Blanking
    PUSH HL
    
    CALL fast_draw.draw_sprite_16x8
    
    POP DE 
    POP DE
    POP DE

    ; Draw alien explosion
    LD HL,(IY+STATE_OFFSET_DRAW_COORDS)                 ; Coords
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
    LD A,(alien_count)
    DEC A
    LD (alien_count),A                                 ; LOGPOINT [ALIENS] alien_count=${A}
    
    RET

event_alien_hit_by_player_missile_end:
    PUSH AF,HL,IX

    ; Done exploding - erase the explosion
    LD HL,(_exploding_alien)                           
    LD IX,HL

    LD HL,(IX+STATE_OFFSET_DRAW_COORDS)
    PUSH HL

    LD HL,sprites.ALIEN_EXPLOSION
    PUSH HL

    LD L,utils.TRUE_VALUE
    PUSH HL

    CALL fast_draw.draw_sprite_16x8
    
    POP HL  
    POP HL
    POP HL 

    ; Flag that there is no alien exploding
    LD A,utils.FALSE_VALUE
    LD (_alien_is_exploding),A

    LD A,utils.TRUE_VALUE
    LD (_alien_pack_moving),A

    POP IX,HL,AF

    RET
event_alien_landed_begin:
event_alien_missile_hit_player_begin:
    PUSH AF

    ; Is there a missile exploding?
    LD A,(_alien_is_exploding)
    BIT utils.TRUE_BIT,A
    JR Z,.none_exploding
    
    ; Blank the explosion and reset explosion state
    CALL event_alien_hit_by_player_missile_end        
    
.none_exploding:
    ; Stop the pack moving
    LD A,utils.FALSE_VALUE                          
    LD (_alien_pack_moving),A

    POP AF

    RET

event_alien_landed_end:
event_alien_missile_hit_player_end:
    PUSH AF

    ; Start the pack moving again
    LD A,utils.TRUE_VALUE
    LD (_alien_pack_moving),A

    POP AF

    RET

