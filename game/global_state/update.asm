update:
    PUSH AF

    LD A,(_game_state)                                      ; Grab the current game state
    
    BIT _GAME_STATE_LIFE_LOST_PAUSING_BIT,A                 ; Is the game paused due to player being hit?
    JR NZ,.life_lost_pausing                                ; Y - handle it

    BIT _GAME_STATE_ALIEN_EXPLODING_BIT,A                   ; Is an alien exploding?
    JR NZ,.state_alien_exploding                            ; Y - handle it
    
    JR .done                                                ; N - all done

.state_alien_exploding                                      ; An alien is exploding
    LD A,(_alien_exploding_count_down)                      ; Reduce cycles left to pauseable while alien explodes
    DEC A
    LD (_alien_exploding_count_down),A                  
    JR NZ,.done                                             ; Done exploding? N then done
    
    ; Alien done exploding
    CALL aliens.event_alien_hit_by_player_missile_end       ; Inform the alien pack  
    CALL player_missile.event_alien_explosion_done          ; Inform the player missile
    
    LD A,_GAME_STATE_RUNNING_VALUE                          ; Update global state to nominal running
    LD (_game_state),A

    JR .done

.life_lost_pausing:
    LD A,(_life_lost_pause_count_down)                      ; Reduce pause counter
    DEC A
    LD (_life_lost_pause_count_down),A

    JR NZ,.done                                             ; Not zero?  Then done.

    CALL player.event_alien_missile_hit_player_end          ; Done pausing, inform game objects
    CALL player_missile.event_alien_missile_hit_player_end
    CALL alien_missiles.event_alien_missile_hit_player_end
    CALL aliens.event_alien_missile_hit_player_end

    LD A,_GAME_STATE_RUNNING_VALUE                          ; Update global state to nominal running
    LD (_game_state),A

    JR .done
    
.done
    POP AF

    RET

