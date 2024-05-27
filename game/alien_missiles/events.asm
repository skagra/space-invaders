
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

    PUSH HL,IX,IY

    LD  IX,0                                                ; Point IX to the stack
    ADD IX,SP  

    LD HL,(IX+.PARAM_ALIEN_MISSILE)  
    LD IY,HL      
    
    LD (IY+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_MISSILES_COLLIDED_VALUE 

    POP IY,IX,HL

    RET

    MACRO REMOVE_ALIENT_MISSILE num

        LD IX,_ALIEN_MISSILE_num
        BIT _ALIEN_MISSILE_STATE_NOT_ACTIVE_BIT,(IX+_ALIEN_MISSILE_OFFSET_STATE)
        JR NZ,.skip

        LD DE,_ALIEN_MISSILE_num
        LD HL,_current_alien_missile_ptr
        LD (HL),DE
        
        CALL blank

        LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
        
        LD A,0x00
        LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

.skip

    ENDM


event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL,IX

    LD A,utils.FALSE_VALUE
    LD (_enabled),A

    REMOVE_ALIENT_MISSILE 0
    REMOVE_ALIENT_MISSILE 1
    REMOVE_ALIENT_MISSILE 2
    
    POP IX,HL,DE,AF

    RET
    
event_alien_missile_hit_player_end:
    LD A,utils.TRUE_VALUE
    LD (_enabled),A

    RET
    