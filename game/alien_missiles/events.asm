
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

event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL,IX

    LD A, _ALIEN_MISSILES_GLOBAL_STATE_PAUSED_VALUE
    LD (_alien_missiles_global_state),A

    LD IX,_ALIEN_MISSILE_0
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_0

    LD DE,_ALIEN_MISSILE_0
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE

.skip_0
    LD IX,_ALIEN_MISSILE_1
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_1

    LD DE,_ALIEN_MISSILE_1
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE

.skip_1
    LD IX,_ALIEN_MISSILE_2
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_2

    LD DE,_ALIEN_MISSILE_2
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE

.skip_2
    POP IX,HL,DE,AF

    RET
    
event_alien_missile_hit_player_end:
    LD A, _ALIEN_MISSILES_GLOBAL_STATE_ACTIVE_VALUE
    LD (_alien_missiles_global_state),A

    RET
    