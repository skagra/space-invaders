;------------------------------------------------------------------------------
; Update saucer state
; 
; Usage:
;   CALL update
;------------------------------------------------------------------------------
update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_saucer_state)

    BIT _STATE_NO_SAUCER_BIT,A
    JR NZ,.no_saucer
    
    BIT _STATE_LEAVING_SCREEN_BIT,A
    JP NZ,.leaving_screen

    BIT _STATE_ACTIVE_BIT,A
    JR NZ,.active

    BIT _STATE_EXPLODING_BIT,A
    JP NZ,.exploding

    BIT _STATE_DONE_EXPLODING_BIT,A
    JP NZ,.done_exploding

    BIT _STATE_SHOWING_SCORE_BIT,A
    JP NZ,.showing_score

    BIT _STATE_DONE_SHOWING_SCORE_BIT,A
    JP NZ,.done_showing_score

    ; ASSERT This code should never be reached

    JP .done

.no_saucer:
    ; Is the saucer timer enabled?  
    LD A,(timer_enabled)
    BIT utils.TRUE_BIT,A
    JP Z,.done                                              ; Time disabled - so done

    ; Increment saucer timer                                
    LD HL,(_saucer_timer)
    INC HL
    LD (_saucer_timer),HL

    ; Is saucer launching enabled?
    LD A,(enabled)
    BIT utils.TRUE_BIT,A
    JP Z,.done                                              ; Launching disabled - so done

    ; Is it time to launch a new saucer?   
    LD A,(_saucer_timer+1)                                       
    CP _SAUCER_LAUNCH_GAME_LOOP_FREQUENCY                    
    JP C,.done                                              ; Not time to launch yet - so done

    ; Yes - Launch a new saucer
    LD A,_STATE_ACTIVE_VALUE
    LD (_saucer_state),A

    LD A,(player_missile.shot_count)                        ; TODO Should not reference this directly
    BIT 0,A                                                 ; Odd number of shots fired?
    JR NZ,.odd                                              ; Yes - so handle it

    LD A,_SAUCER_START_LEFT                                 ; Even number of shots - so start on the left
    LD (_saucer_x),A

    LD A,_DIRECTION_RIGHT_VALUE                             ; And move to the right
    LD (_direction),A

    JP .done

.odd:
    LD A,_SAUCER_START_RIGHT                                ; Odd number of shots - so start on the right
    LD (_saucer_x),A

    LD A,_DIRECTION_LEFT_VALUE                              ; And move to the left
    LD (_direction),A

    JR .done

.active:
    LD A,(_direction)                                       ; Direction
    BIT _DIRECTION_LEFT_BIT,A                               ; Moving left?
    JR NZ,.moving_left                                      ; Yes - so handle it

    LD A,(_saucer_x)                                        ; Moving right
    INC A                                                   ; Increment x coord 
    LD (_saucer_x),A

    CP _SAUCER_MAX_X                                        ; Has the saucer reached the rhs of the screen?
    JR NC,.reached_right_edge                               ; Yes - handle it
 
    JR .done                                                ; No - we are done

.reached_right_edge:
    LD A,_STATE_LEAVING_SCREEN_VALUE                        ; Set state to indicate saucer is leaving the screen
    LD (_saucer_state),A
    
    JR .done

.moving_left:
    LD A,(_saucer_x)                                        ; Moving left
    DEC A                                                   ; Decrement x coord
    LD (_saucer_x),A

    CP _SAUCER_MIN_X                                        ; Has the saucer reached the lhs of the screen?
    JR Z,.reached_left_edge                                 ; Yes - handle it
    JR C,.reached_left_edge

    JR .done                                                ; No - we are done

.reached_left_edge:
    LD A,_STATE_LEAVING_SCREEN_VALUE                        ; Set state to indicate saucer is leaving the screen
    LD (_saucer_state),A

    JR .done

.leaving_screen
    LD A,_STATE_NO_SAUCER_VALUE                             ; Set state to no saucer as saucer has left the screen
    LD (_saucer_state),A

    LD HL,0x0000                                            ; Reset the launch timer
    LD (_saucer_timer),HL

    JR .done

.exploding:
    LD A,(_explosion_countdown)                             ; Update explosion count down
    DEC A
    LD (_explosion_countdown),A

    JR NZ,.done                                             ; Have we reached the end of the count down?  If not then done

    LD A,_STATE_DONE_EXPLODING_VALUE                        ; End of count down - so set state to flag done exploding
    LD (_saucer_state),A

    JR .done

.done_exploding:
    LD A,_STATE_SHOWING_SCORE_VALUE                         ; Exploding done - so move state on to display the "mystery" score
    LD (_saucer_state),A

    LD A,_SCORE_CYCLE_COUNT                                 ; Initialize the count down to hold the score on screen
    LD (_score_countdown),A                

    JR .done

.showing_score:
    LD A,(_score_countdown)                                 ; Update the score display count down
    DEC A
    LD (_score_countdown),A

    JR NZ,.done                                             ; End of count down?  If not then done

    LD A,_STATE_DONE_SHOWING_SCORE_VALUE                    ; End of count down - so set state to indicate it is done
    LD (_saucer_state),A

    JR .done

.done_showing_score:
    LD A,_STATE_NO_SAUCER_VALUE                             ; Score display is over so set state to indicate there's no saucer
    LD (_saucer_state),A

    LD HL,0x0000                                            ; Reset the saucer launch timer
    LD (_saucer_timer),HL

    JR .done

.done
    POP HL,DE,BC,AF

    RET
