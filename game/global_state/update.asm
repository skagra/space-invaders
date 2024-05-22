update:
    PUSH AF

    LD A,(_game_state)                                  ; Grab the current game state
    BIT _GAME_STATE_ALIEN_EXPLODING_BIT,A                ; Is an alien exploding?
    JR NZ,.state_alien_exploding                        ; Y - handle it
    
    JR .done                                            ; N - all done

.state_alien_exploding                                  ; An alien is exploding
    LD A,(_alien_exploding_count_down)                  ; Reduce cycles left to pauseable while alien explodes
    DEC A
    LD (_alien_exploding_count_down),A                  
    JR NZ,.done                                         ; Done exploding? N then done.
    
    ; Alien done exploding
    CALL aliens.event_alien_explosion_done              ; Inform the alien pack  
    CALL player_missile.event_alien_explosion_done      ; Inform the player missile
    
    LD A,_GAME_STATE_RUNNING_VALUE                             ; Update global state to nominal running
    LD (_game_state),A

.done
    POP AF

    RET

