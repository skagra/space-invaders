update:
    PUSH AF,BC,DE,HL

    LD A,(timer_enabled)
    BIT utils.TRUE_BIT,A
    JR Z,.dont_update_timer

    ; Increment saucer timer                                ; TODO Need a reset mechanism ... maybe this should be controlled by saucer?
    LD HL,(saucer_timer)
    INC HL
    LD (saucer_timer),HL

.dont_update_timer:
    ; Grab the current missile state
    LD A,(_saucer_state)

    BIT _SAUCER_STATE_NO_SAUCER_BIT,A
    JR NZ,.no_saucer
    
    BIT _SAUCER_LEAVING_SCREEN_BIT,A
    JP NZ,.leaving_screen

    BIT _SAUCER_STATE_ACTIVE_BIT,A
    JR NZ,.active

    BIT _SAUCER_STATE_EXPLODING_BIT,A
    JP NZ,.exploding

    BIT _SAUCER_STATE_DONE_EXPLODING_BIT,A
    JP NZ,.done_exploding

    BIT _SAUCER_STATE_SHOWING_SCORE_BIT,A
    JP NZ,.showing_score

    BIT _SAUCER_STATE_DONE_SHOWING_SCORE_BIT,A
    JP NZ,.done_showing_score


    ; ASSERT This code should never be reached

    JP .done

.no_saucer:
    ; Is saucer launching enabled?
    LD A,(enabled)
    BIT utils.TRUE_BIT,A
    JP Z,.done

    ; Is it time to launch a new saucer?   
    LD A,(saucer_timer+1)                                       
    CP SAUCER_LAUNCH_GAME_LOOP_FREQUENCY                    
    JP C,.done

    LD A,_SAUCER_STATE_ACTIVE_VALUE
    LD (_saucer_state),A

    LD A,(player_missile.shot_count)                        ; TODO Should not reference this directly
    BIT 0,A                                                 ; Odd?
    JR NZ,.odd

    LD A,_SAUCER_START_LEFT
    LD (saucer_x),A

    LD A,_DIRECTION_RIGHT_VALUE
    LD (_direction),A

    JP .done

.odd
    LD A,_SAUCER_START_RIGHT
    LD (saucer_x),A

    LD A,_DIRECTION_LEFT_VALUE
    LD (_direction),A

    JR .done

.active:
    LD A,(_direction)
    BIT _DIRECTION_LEFT_BIT,A
    JR NZ,.moving_left

    LD A,(saucer_x)
    INC A                                                   
    LD (saucer_x),A

    CP _SAUCER_MAX_X
    JR NC,.reached_right_edge

    JR .done

.reached_right_edge:
    LD A,_SAUCER_STATE_LEAVING_SCREEN_VALUE
    LD (_saucer_state),A
    
    JR .done

.moving_left:
    LD A,(saucer_x)
    DEC A                                                   
    LD (saucer_x),A

    CP _SAUCER_MIN_X
    JR Z,.reached_left_edge
    JR C,.reached_left_edge

    JR .done

.reached_left_edge:
    LD A,_SAUCER_STATE_LEAVING_SCREEN_VALUE
    LD (_saucer_state),A

    JR .done

.leaving_screen
    LD A,_SAUCER_STATE_NO_SAUCER_VALUE
    LD (_saucer_state),A

    LD HL,0x0000
    LD (saucer_timer),HL

    JR .done

.exploding:
    LD A,(exploding_counter)
    DEC A
    LD (exploding_counter),A

    JR NZ,.done

    LD A,_SAUCER_STATE_DONE_EXPLODING_VALUE
    LD (_saucer_state),A

    JR .done

.done_exploding:
    LD A,_SAUCER_STATE_SHOWING_SCORE
    LD (_saucer_state),A

    ; LD HL,0x0000
    ; LD (saucer_timer),HL

    LD A,20
    LD (showing_score_counter),A                ; TODO Move out to a constant

    JR .done

.showing_score
    LD A,(showing_score_counter)
    DEC A
    LD (showing_score_counter),A

    JR NZ,.done

    LD A,_SAUCER_STATE_DONE_SHOWING_SCORE
    LD (_saucer_state),A

    JR .done

.done_showing_score
    LD A,_SAUCER_STATE_NO_SAUCER_VALUE
    LD (_saucer_state),A

    LD HL,0x0000
    LD (saucer_timer),HL

    JR .done

.done
    POP HL,DE,BC,AF

    RET

exploding_counter: BLOCK 1
showing_score_counter: BLOCK 1
score:  BLOCK 2