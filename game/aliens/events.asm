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
    ; LD A,utils.TRUE_VALUE
    ; LD (_pack_halted),A

    LD A,_ALIEN_PACK_STATE_PAUSED_VALUE
    LD (_alien_pack_state),A

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
    
    RET

; .EXPLODING_ALIEN_DELAY EQU  15

event_alien_missile_hit_player_begin:
    PUSH AF

  ;  CALL event_alien_explosion_done        ; TODO I need to know there is an explosion first
                                            ; BUG to be able to blank from alien missile hit player
    LD A,_ALIEN_PACK_STATE_PAUSED_VALUE     ; Explosion is not undrawn as we are overloading PAUSED
    LD (_alien_pack_state),A

    POP AF

    RET

event_alien_missile_hit_player_end:
    PUSH AF

    LD A,_ALIEN_PACK_STATE_ACTIVE_VALUE
    LD (_alien_pack_state),A

    POP AF

    RET

event_alien_explosion_done:
    PUSH AF,HL

    ; Done exploding - erase the explosion
    LD HL,(_exploding_alien)                           
    LD IX,HL

    LD HL,(IX+_STATE_OFFSET_DRAW_COORDS)
    PUSH HL

    LD HL, sprites.ALIEN_EXPLOSION
    PUSH HL

    LD L,utils.TRUE_VALUE
    PUSH HL

    CALL fast_draw.draw_sprite_16x8
    
    POP HL  
    POP HL
    POP HL 

    ; Start the pack moving again
    ; LD A,utils.FALSE_VALUE
    ; LD (_pack_halted),A

    LD A,_ALIEN_PACK_STATE_ACTIVE_VALUE
    LD (_alien_pack_state),A

    POP HL,AF

    RET