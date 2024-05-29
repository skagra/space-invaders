;------------------------------------------------------------------------------
;
; Update the missile state based on its current state, location 
; and collision status
;
; Usage:
;   CALL blank_missile
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; Internal state:
;   _missile_state - Current state of the missile, values from _MISSILE_STATE_*
;   _missile_x - X coord of the missile
;   _missile_blank_y - Y coord to erase the missile
;   _missile_draw_y - Y coord to draw the missile
;   _collision_detected - Set to indicate a missile collision was detected in 
;       the draw phase
;
; External state:
;   keyboard.keys_down - To test for fire button being pressed
;   player.player_x - X coordinate of the player base
;
;------------------------------------------------------------------------------

update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_missile_state)

    ; Is there a missile on the screen?
    BIT _MISSILE_STATE_NO_MISSILE_BIT,A
    JR NZ,.no_missile

    ; New missile?
    BIT _MISSILE_STATE_NEW_BIT,A
    JR NZ,.new

    ; Do we have an active missile?
    BIT _MISSILE_STATE_ACTIVE_BIT,A
    JR NZ,.active

    ; Hit a base?
    BIT _MISSILE_STATE_HIT_A_SHIELD_BIT,A
    JP NZ,.missile_state_hit_a_shield

    ; Collided with other missile?
    BIT _MISSILE_STATE_MISSILES_COLLIDED_BIT,A
    JP NZ,.missiles_collided

    ; Top of screen?
    BIT _MISSILE_STATE_TOP_OF_SCREEN_BIT,A
    JR Z,.not_tos

    LD A,(_tos_sub_state)

    ; Reached the top of the screen?
    BIT _TOS_SUB_STATE_REACHED_TOP_OF_SCREEN_BIT,A
    JR NZ,.reached_top_of_screen 

    ; Are we in the loop keep the missile explosion displayed?
    BIT _TOS_SUB_STATE_AT_TOP_OF_SCREEN_BIT,A
    JR NZ,.at_top_of_screen 

    ; Are we done expoding the missile at top of screen?
    BIT _TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN_BIT,A
    JP NZ,.done_at_top_of_screen 

.not_tos:
    ; This should never be reached!
    ; ASSERTION This code should never be reached

    JP .done    

.no_missile
    ; No current missile - is the fire button down?
    LD DE,(keyboard.keys_down)                          ; Read the keyboard
    BIT keyboard.FIRE_KEY_DOWN_BIT,E                    ; Fire pressed?
    JP Z,.done                                          ; No

    LD A,(_can_fire)
    BIT utils.TRUE_BIT,A
    JR Z,.done

    ; Fire pressed - init a new missile
    LD HL,_missile_state                                 
    LD (HL),_MISSILE_STATE_NEW

    ; Calculate start x coord for missile
    LD A,(player.player_x)
    ADD A,0x04
    LD HL,_missile_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,layout.PLAYER_MISSILE_START_Y 
    LD HL,_missile_y       
    LD (HL),A

    JR .done

.new:
    LD HL,_missile_state                                
    LD (HL),_MISSILE_STATE_ACTIVE

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
    LD A,_MISSILE_STATE_TOP_OF_SCREEN                                          
    LD (_missile_state),A

    LD A,_TOS_SUB_STATE_REACHED_TOP_OF_SCREEN
    LD (_tos_sub_state),A

    JR .done

.reached_top_of_screen:
    LD A,_TOS_SUB_STATE_AT_TOP_OF_SCREEN
    LD (_tos_sub_state),A                                                

    LD A,_MISSILE_EXPLOSION_CYCLES
    LD (_missile_explosion_cycle_count),A

    JR .done

.at_top_of_screen:
    LD A,(_missile_explosion_cycle_count)
    DEC A
    LD (_missile_explosion_cycle_count),A
    JR NZ,.done

    LD A,_TOS_SUB_STATE_DONE_AT_TOP_OF_SCREEN                                                 
    LD (_tos_sub_state),A

    JR .done

.done_at_top_of_screen:
    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    JR .done

.hit_an_alien
    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    JR .done

.missile_state_hit_a_shield:
    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    JR .done

.missiles_collided:
    LD A,_MISSILE_STATE_NO_MISSILE
    LD (_missile_state),A

    JR .done

.done
    POP HL,DE,BC,AF

    RET

    