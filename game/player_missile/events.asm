;------------------------------------------------------------------------------
; Process start of alien landed or alien missile hitting the player.
;
; Usage:
;   CALL event_alien_landed_begin / event_alien_missile_hit_player_begin
;------------------------------------------------------------------------------

event_alien_landed_begin:
event_alien_missile_hit_player_begin:
    PUSH AF

    LD A,utils.FALSE_VALUE                              ; Disable firing
    LD (_can_fire),A

    LD A,(_missile_state)                               
    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A              ; At top of screen?
    JR NZ,.explosion                                    ; Yes - handle it

    CALL _blank_missile                                 ; No - erase the player missile

    JR .set_state

.explosion:
    CALL _blank_explosion                               ; Erase the missile explosion
    ; Fall through

.set_state:
    LD A,_MISSILE_STATE_NO_MISSILE_VALUE                      ; Flag there is now no missile
    LD (_missile_state),A

    POP AF

    RET

;------------------------------------------------------------------------------
; Process end of alien landed or alien missile hitting the player.
;
; Usage:
;   CALL event_alien_landed_end / event_alien_missile_hit_player_end
;------------------------------------------------------------------------------

event_alien_landed_end:
event_alien_missile_hit_player_end:
    PUSH AF

    LD A,utils.TRUE_VALUE                               ; Enable firing
    LD (_can_fire),A

    POP AF

    RET

;------------------------------------------------------------------------------
; Process player missile hitting an alien.
;
; Usage:
;   CALL event_player_missile_hit_alien 
;------------------------------------------------------------------------------

event_player_missile_hit_alien:
    PUSH AF

    CALL _blank_missile                                 ; Blank the missile missile immediately

    LD A,_MISSILE_STATE_NO_MISSILE_VALUE                      ; Set state to indicate we have no current missile
    LD (_missile_state),A

    LD A,utils.FALSE_VALUE                              ; Can't fire another missile while an alien is exploding
    LD (_can_fire),A

    POP AF
    
    RET 

;------------------------------------------------------------------------------
; Process end of alien explosion.
;
; Usage:
;   CALL event_alien_explosion_done 
;------------------------------------------------------------------------------

event_alien_explosion_done:
    PUSH AF

    LD A,utils.TRUE_VALUE                               ; Alien done exploding, so allow player to fire missiles 
    LD (_can_fire),A

    POP AF

    RET

event_player_missile_hit_shield:
    PUSH AF
    
    LD A,_MISSILE_STATE_NO_MISSILE_VALUE                              
    LD (_missile_state),A
    
    CALL _blank_missile

    LD A,(_missile_y)
    DEC A                                               ; Update Y slightly so repeated hits on shields continue to destroy sections
    DEC A                                               
    LD (_missile_y),A

    CALL _blank_explosion

    POP AF
    
    RET

event_missiles_collided:
    PUSH AF
    
    LD A,_MISSILE_STATE_MISSILES_COLLIDED_VALUE                            
    LD (_missile_state),A              

    POP AF
    
    RET 