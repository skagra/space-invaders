
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
    PUSH IX

    ; Point IX to current missle struct
    LD IX,(_current_alien_missile_ptr)                     

    ; Set state
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE
    
    POP IX

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
    
    LD (IY+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_MISSILES_COLLIDED_VALUE 

    POP IY,IX,HL,AF

    RET

event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL,IX

    LD A,utils.FALSE_VALUE
    LD (_enabled),A

    LD IX,_ALIEN_MISSILE_0
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_0

    LD DE,_ALIEN_MISSILE_0
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
    
    LD A,0x00
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

.skip_0
    LD IX,_ALIEN_MISSILE_1
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_1

    LD DE,_ALIEN_MISSILE_1
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
    
    LD A,0x00
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

.skip_1
    LD IX,_ALIEN_MISSILE_2
    BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
    JR NZ,.skip_2

    LD DE,_ALIEN_MISSILE_2
    LD HL,_current_alien_missile_ptr
    LD (HL),DE
    
    CALL blank

    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
    
    LD A,0x00
    LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

.skip_2
    POP IX,HL,DE,AF

    RET
    
event_alien_missile_hit_player_end:
    LD A,utils.TRUE_VALUE
    LD (_enabled),A

    RET
    