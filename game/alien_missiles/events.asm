
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

.PARAM_ALIEN_MISSILE: EQU 8

    PUSH HL,IX,IY

    LD  IX,0                                                ; Point IX to the stack
    ADD IX,SP  

    LD HL,(IX+.PARAM_ALIEN_MISSILE)                         ; Grab the alien missile involved in the collision
    LD IY,HL      
    
    ; Flag it as collided
    LD (IY+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_MISSILES_COLLIDED_VALUE 

    POP IY,IX,HL

    RET

    MACRO REMOVE_ALIEN_MISSILE num

        LD IX,_ALIEN_MISSILE_num                            ; The missile    
        LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)

        ; Is the missile exploding at the bottom of the screen?
        AND _ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_VALUE | _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_VALUE
        JR Z,.dont_modify                                   ; No - nothing to modify

        ; Change missile state such that the explosion will be erased
        LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_VALUE

.dont_modify:
        LD DE,_ALIEN_MISSILE_num                            ; Make the missile the current missile
        LD HL,_current_alien_missile_ptr
        LD (HL),DE
        
        CALL blank                                          ; Erase it from the screen

        ; Flag missile as nolonger active
        LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
        
        ; And reset its step count
        LD A,0x00
        LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

    ENDM

event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL,IX

    LD A,utils.FALSE_VALUE                                  ; Disable missiles
    LD (_enabled),A
    
    ; Remove each of the alien missiles from the screen
    REMOVE_ALIEN_MISSILE 0
    REMOVE_ALIEN_MISSILE 1
    REMOVE_ALIEN_MISSILE 2
    
    POP IX,HL,DE,AF

    RET
    
event_alien_missile_hit_player_end:
    LD A,utils.TRUE_VALUE                                   ; Enable missiles
    LD (_enabled),A

    RET
    