update:
    PUSH AF,HL

    ; Increment count of game loops
    LD HL,(game_loop_count)
    INC HL
    LD (game_loop_count),HL

    ; Process saucer launching

    ; Is the pack low enough to process saucer launching?
    LD A,(aliens._pack_bottom)
    CP SAUCER_LAUNCH_MIN_Y
    JR C,.disable_saucer_and_timer

    ; Enable the saucer timer
    LD A,utils.TRUE_VALUE
    LD (saucer.timer_enabled),A

    ; Do we have enough aliens left to allow launching of the saucer?
    LD A,(aliens.alien_count)
    CP SAUCER_LAUNCH_MIN_ALIENS 
    JR C,.disable_saucer

    ; Enable the saucer 
    LD A,utils.TRUE_VALUE
    LD (saucer.enabled),A

    JR .saucer_done

.disable_saucer:
    ; Disable the saucer 
    LD A,utils.FALSE_VALUE
    LD (saucer.enabled),A
    JR .saucer_done

.disable_saucer_and_timer:
    ; Disable the saucer timer
    LD A,utils.FALSE_VALUE
    LD (saucer.timer_enabled),A

    ; Disable the saucer
    LD (saucer.enabled),A

.saucer_done:
    LD A,(_life_lost_pausing)
    BIT utils.TRUE_BIT,A                                    ; Is the game paused due to player being hit?
    JR NZ,.life_lost_pausing                                ; Y - handle it

    LD A,(_alien_exploding)
    BIT utils.TRUE_BIT,A                                    ; Is an alien exploding?
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
    
    LD A,utils.TRUE_VALUE                                   ; Update global state to nominal running
    LD (_alien_exploding),A

    JR .done

.life_lost_pausing:
    LD A,(_life_lost_pause_count_down)                      ; Reduce pause counter
    DEC A
    LD (_life_lost_pause_count_down),A
    JR NZ,.done                                             ; Not zero?  Then done.

    ; Immediately blank the explosion
    CALL player.blank
    CALL fast_draw.flush_buffer_to_screen_16x8

    ; Short delay before continuing
    CALL utils.delay_one_second

    LD A,(player_lives.player_lives_1)                      ; Game over?
    AND A
    JR NZ,.continue                                         ; No then continue playing

    LD A,utils.FALSE_VALUE                                  ; Game over
    LD (_game_running),A

    JR .done

.continue:
    LD A,(_alien_landed)
    BIT utils.TRUE_BIT,A
    JR Z,.not_landed

    CALL player.event_alien_landed_end          
    CALL player_missile.event_alien_landed_end
    CALL alien_missiles.event_alien_landed_end
    CALL aliens.event_alien_landed_end

    JR .reset

.not_landed:
    CALL player.event_alien_missile_hit_player_end          ; Done pausing, inform game objects
    CALL player_missile.event_alien_missile_hit_player_end
    CALL alien_missiles.event_alien_missile_hit_player_end
    CALL aliens.event_alien_missile_hit_player_end

.reset
    LD A,utils.FALSE_VALUE                                  ; Update global state to nominal running
    LD (_alien_exploding),A
    LD (_life_lost_pausing),A

    JR .done
    
.done
    POP HL,AF

    RET

