
;------------------------------------------------------------------------------
; Current alien missile has hit a shield
; 
; Usage:
;   CALL event_alien_missile_hit_shield
;------------------------------------------------------------------------------

event_alien_missile_hit_shield:
    PUSH IX

    ; Point IX to current missile struct
    LD IX,(_current_alien_missile_ptr)                     

    ; Set state
    LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_HIT_SHIELD_VALUE  ; TODO - Not sure this should be a state - just blank and move on?
    
    POP IX

    RET

;------------------------------------------------------------------------------
; The player missile has collided with an alien missile.
; 
; Usage:
;   PUSH rr - The alien missile struct collided with
;   CALL event_alien_missile_hit_shield
;   POP rr
;------------------------------------------------------------------------------

event_missiles_collided:

.PARAM_ALIEN_MISSILE: EQU 10

    PUSH DE,HL,IX,IY

    LD  IX,0                                                    ; Point IX to the stack
    ADD IX,SP  

    LD HL,(IX+.PARAM_ALIEN_MISSILE)                             ; Grab the alien missile involved in the collision
    LD IY,HL      
    
    LD HL,(_current_alien_missile_ptr)                          ; Stash the current alien missile pointer                     
    LD (.current_alien_missile_ptr_copy),HL                     

    LD (_current_alien_missile_ptr),IY                          ; Set current alien missile ptr to that involved in the collision

    CALL blank                                                  ; Erase the missile

    LD HL,(.current_alien_missile_ptr_copy)                     ; Reset current missile ptr
    LD (_current_alien_missile_ptr),HL

    ; Flag it as not active
    LD (IY+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE

    ; Reset its count
    LD (IY+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),0

    POP IY,IX,HL,DE

    RET

.current_alien_missile_ptr_copy: BLOCK 2

    MACRO REMOVE_ALIEN_MISSILE num

        LD IX,_ALIEN_MISSILE_num                                ; The missile    
        LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)

        ; Is the missile exploding at the bottom of the screen?
        AND _ALIEN_MISSILE_STATE_AT_BOTTOM_OF_SCREEN_VALUE | _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_VALUE
        JR Z,.dont_modify                                       ; No - nothing to modify

        ; Change missile state such that the explosion will be erased
        LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_VALUE

.dont_modify:
        LD DE,_ALIEN_MISSILE_num                                ; Make the missile the current missile
        LD HL,_current_alien_missile_ptr
        LD (HL),DE
        
        CALL blank                                              ; Erase it from the screen

        ; Flag missile as no longer active
        LD (IX+_ALIEN_MISSILE_OFFSET_STATE),_ALIEN_MISSILE_STATE_NOT_ACTIVE_VALUE
        
        ; And reset its step count
        LD A,0x00
        LD (IX+_ALIEN_MISSILE_OFFSET_RELOAD_STEP_COUNT),A 

    ENDM

;------------------------------------------------------------------------------
; Either an alien has landed or an alien missile has hit the player
; 
; Usage:
;   CALL event_alien_landed_begin
;   or
;   CALL event_alien_missile_hit_player_begin
;------------------------------------------------------------------------------

event_alien_landed_begin:
event_alien_missile_hit_player_begin:
    PUSH AF,DE,HL,IX

    LD A,utils.FALSE_VALUE                                      ; Disable missiles
    LD (_enabled),A
    
    ; Remove each of the alien missiles from the screen
    REMOVE_ALIEN_MISSILE 0
    REMOVE_ALIEN_MISSILE 1
    REMOVE_ALIEN_MISSILE 2
    
    POP IX,HL,DE,AF

    RET

;------------------------------------------------------------------------------
; Either an alien landed or an alien missile hit the player period 
; (pause/explosion) has completed.
; 
; Usage:
;   CALL event_alien_landed_end
;   or
;   CALL event_alien_missile_hit_player_end
;------------------------------------------------------------------------------

event_alien_landed_end:   
event_alien_missile_hit_player_end:
    LD A,utils.TRUE_VALUE                                       ; Enable missiles
    LD (_enabled),A

    RET

;------------------------------------------------------------------------------
; The player missile has hit an alien
; 
; Usage:
;   PUSH rr - Alien count in LSB
;   POP rr - Player score 
;   CALL event_player_missile_hit_alien
;   POP rr,rr
;------------------------------------------------------------------------------

event_player_missile_hit_alien:

.PARAM_ALIEN_COUNT: EQU 2
.PARAM_SCORE:       EQU 0

    PUSH AF,BC,DE,HL,IX

    PARAMS_IX 5                                                 ; Get the stack pointer

    LD DE,(IX+.PARAM_SCORE)
    LD B,D                                                      ; Score MSB in B

    LD HL,_RELOAD_SCORE_BOUNDARIES                              ; Pointer to reload score boundaries
    LD C,0x00                                                   ; Offset in to reload score boundaries 

.loop
    ; Score > current boundary?
    LD A,(HL)                                                   ; Current score boundary
    CP B                                                        ; Compare with MSB of score
    JR C,.outside                                               ; MSB of score is greater than boundary so next
    JR Z,.outside

    ; Get required reload rate from table
    LD HL,_RELOAD_RATES                                         ; Base of reload rates table
    LD B,0x00                                                   ; MSB of offset = 0, LSB is in C
    ADD HL,BC                                                   ; Update pointer to required reload value
    LD A,(HL)                                                   ; Grab the reload value
    LD (_reload_rate),A                                         ; Store it in the reload rate
    JR .check_alien_delta                                       ; Check alien count

.outside                                                        ; The score MSB was greater than the current boundary
    INC C                                                       ; Increase the offset count
    LD A,C                                                      ; Have we reached the end of the table?
    CP _NUM_RELOAD_RATES
    JR Z,.max_reload_rate                                       ; Yes - so use the fastest reload rate
    INC HL                                                      ; No - move to next entry in score lookup table
    JR .loop

.max_reload_rate:                                               ; Use fastest reload rate
    LD A,_MAX_RELOAD_RATE
    LD (_reload_rate),A                                         
    ; Fall through to check_alien_delta

.check_alien_delta:
    ; LOGPOINT [ALIEN_MISSILES_EVENTS] Reload rate=${A}

    LD A,(IX+.PARAM_ALIEN_COUNT)                                ; Remaining aliens
    CP 0x08                                                     ; Are we down to 8?
    JR NZ,.check_disable_missile                                ; No - nothing to do
    LD A,_MISSILE_DELTA_Y_8_OR_FEWER_ALIENS                     ; Yes - increase the missile speed
    LD (_missile_delta),A                                       ; LOGPOINT [ALIEN_MISSILES_EVENTS] Delta Y=${A}
    ; Fall through to check disable missile

.check_disable_missile:
    LD A,(IX+.PARAM_ALIEN_COUNT)                                ; Remaining aliens
    CP 0x01                                                     ; Done to last alien?
    JR NZ,.done                                                 ; No - Done
    
    LD A,utils.FALSE_VALUE                                      ; Yes - Disable missile type 1
    LD (_missile_1_enabled),A                                   ; LOGPOINT [ALIEN_MISSILES_EVENTS] Missile type 1 disabled
    ; Fall through to done

.done:
    POP IX,HL,DE,BC,AF

    RET
