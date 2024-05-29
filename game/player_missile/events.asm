event_alien_missile_hit_player_begin:
    PUSH AF

    LD A,utils.FALSE_VALUE
    LD (_can_fire),A

    LD A,(_missile_state)
    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A
    JR Z,.not_at_top

    LD A,_TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN
    LD (_tos_sub_state),A

.not_at_top:
    CALL blank

    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    POP AF

    RET

event_alien_missile_hit_player_end:
    PUSH AF

    LD A,utils.TRUE_VALUE
    LD (_can_fire),A

    POP AF

    RET

event_player_missile_hit_alien:
    PUSH AF,HL

    CALL blank                                          ; Blank the missile missile immediately

    LD HL,_missile_state                                ; Set state to indicate we have no current missile
    LD (HL),_MISSILE_STATE_NO_MISSILE

    LD A,utils.FALSE_VALUE                              ; Can't fire another missile while an alien is exploding
    LD (_can_fire),A

    POP HL,AF
    
    RET 

event_alien_explosion_done:
    PUSH AF

    LD A,utils.TRUE_VALUE                               ; Alien done exploding, so allow player to fire missiles 
    LD (_can_fire),A

    POP AF

    RET

event_player_missile_hit_shield:
    PUSH HL
    
    LD HL,_missile_state                                ; Player missile has hit a shield, set state appropriately
    LD (HL),_MISSILE_STATE_HIT_A_SHIELD

    POP HL
    
    RET

event_missiles_collided:
    PUSH HL
    
    LD A,_MISSILE_STATE_MISSILES_COLLIDED                            
    LD (_missile_state),A              

    POP HL
    
    RET 