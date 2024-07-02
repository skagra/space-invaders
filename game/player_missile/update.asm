;------------------------------------------------------------------------------
; Update the missile state based on its current state, location 
; and collision status.
;
; Usage:
;   CALL update
;------------------------------------------------------------------------------

update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_missile_state)

    ; Is there a missile on the screen?
    BIT _MISSILE_STATE_NO_MISSILE_BIT,A
    JR NZ,.no_missile

    ; Do we have an active missile?
    BIT _MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; Collided with other missile?
    BIT _MISSILE_STATE_MISSILES_COLLIDED_BIT,A
    JP NZ,.missiles_collided

    ; ---> Top of screen sub states

    ; Top of screen?
    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A
    JR Z,.not_at_top_of_screen

    LD A,(_tos_sub_state)

    ; Reached the top of the screen?
    BIT _TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.reached_top_of_screen 

    ; Are we in the loop keep the missile explosion displayed?
    BIT _TOS_SUB_STATE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.at_top_of_screen 

    ; Are we done exploding the missile at top of screen?
    BIT _TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JP NZ,.done_at_top_of_screen 

    ; <--- Top of screen sub states

.not_at_top_of_screen:
    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JP .done    

.no_missile
    ; No current missile - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JP Z,.done                                          ; No

    LD A,(_can_fire)                                    ; Is player firing enabled?
    BIT utils.TRUE_BIT,A
    JR Z,.done                                          ; Disabled - so done

    ; Set start x coord
    LD A,(player.player_x)
    ADD A,0x04                                          ; TODO Move this out to a constant value
    LD HL,_missile_x
    LD (HL),A

    ; Set start y coord 
    LD A,layout.PLAYER_MISSILE_START_Y 
    LD HL,_missile_y       
    LD (HL),A

    LD HL,_missile_state                                ; Flag the missile as active  
    LD (HL),_MISSILE_STATE_ACTIVE_VALUE

    LD A,(shot_count)                                   ; Count one more missile fired
    INC A
    LD (shot_count),A

    JR .done

.active:
    ; Check whether the missile has reached to top of the screen
    LD A,(_missile_y)
    CP A,layout.PLAYER_MISSILE_MIN_Y
    JR C,.active_reached_top_of_screen

    ; Active missile moving up the screen
    LD A,(_missile_y)
    SUB _MISSILE_STEP_SIZE
    LD (_missile_y),A
    
    JR .done

.active_reached_top_of_screen:
    LD A,_MISSILE_STATE_TOP_OF_SCREEN_VALUE                                          
    LD (_missile_state),A

    LD A,_TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_VALUE
    LD (_tos_sub_state),A

    JR .done

.reached_top_of_screen:
    LD A,_TOS_SUB_STATE_AT_TOP_OF_SCREEN_VALUE
    LD (_tos_sub_state),A                                                

    LD A,_MISSILE_EXPLOSION_CYCLES
    LD (_missile_explosion_cycle_count),A

    JR .done

.at_top_of_screen:
    LD A,(_missile_explosion_cycle_count)
    DEC A
    LD (_missile_explosion_cycle_count),A
    JR NZ,.done

    LD A,_TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_VALUE                                                 
    LD (_tos_sub_state),A

    JR .done

.done_at_top_of_screen:
    LD A,_MISSILE_STATE_NO_MISSILE_VALUE
    LD (_missile_state),A

    JR .done

.hit_an_alien
    LD A,_MISSILE_STATE_NO_MISSILE_VALUE
    LD (_missile_state),A

    JR .done

.missiles_collided:
    LD A,_MISSILE_STATE_NO_MISSILE_VALUE
    LD (_missile_state),A

    JR .done

.done
    POP HL,DE,BC,AF

    RET

    