
;------------------------------------------------------------------------------
;
; Current alien missile has hit a shield
; 
; Usage:
;   CALL event_alien_missile_hit_shield
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

event_alien_missile_hit_shield:
    PUSH AF,DE,HL,IX

    LD IX,(_current_alien_missile_ptr)                      ; Point IX to current missle struct

    ; Set state
    LD A,_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A  
    
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Coords
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION_DIMS              ; Dimensions
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION                   ; Spite/mask
    PUSH DE

    LD E,utils.TRUE_VALUE                                   ; Drawing (not blanking)
    PUSH DE

    LD DE,collision.dummy_collision                         ; Where to record collision data
    PUSH DE
    
    CALL draw.draw_sprite       

    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,HL,DE,AF

    RET

;------------------------------------------------------------------------------
;
; The player missile has collided with an alien missile
; 
; Usage:
;   PUSH rr - The alien missile struct collided with
;   CALL event_alien_missile_hit_shield
;   POP rr
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

event_missiles_collided:
.PARAM_ALIEN_MISSILE: EQU 10

    PUSH AF,HL,IX,IY

    LD  IX,0                                                ; Point IX to the stack
    ADD IX,SP  

    LD HL,(IX+.PARAM_ALIEN_MISSILE)  
    LD IY,HL      
    
    LD A,_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE              ; TODO A state model is needed to handle missile-missile collision
    LD (IY+_ALIEN_MISSILE_OFFSET_STATE),A  

    POP IY,IX,HL,AF

    RET

event_alien_missile_hit_player:
    PUSH AF,IX

    LD A,_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE
    LD IX,(_current_alien_missile_ptr) 
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),A

    POP IX,AF

    RET
    
    