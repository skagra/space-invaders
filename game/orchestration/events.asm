event_player_missile_hit_alien:

.PARAM_TARGET_ALIEN: EQU 0                       
    
    PUSH AF,HL,IX,IY

    LD A,(_life_lost_pausing)                           ; If player is exploding ignore this event
    BIT utils.TRUE_BIT,A
    JR NZ,.done

    PARAMS_IX 4                                         ; Get the stack pointer

    ; Inform the player missile 
    CALL player_missile.event_player_missile_hit_alien

    ; Inform the alien pack 
    LD HL,(IX+.PARAM_TARGET_ALIEN)
    PUSH HL
    CALL aliens.event_alien_hit_by_player_missile_begin
    POP HL

    ; Inform scoring 
    LD IY,HL
    LD HL,(IY+aliens.STATE_OFFSET_TYPE)                                      
    PUSH HL
    CALL scoring.event_alien_hit_by_player_missile
    POP HL

    ; Draw the player's score                           ; TODO - Maybe this should be sending an event?
    CALL game_screen.print_score_player_1 

    LD A,utils.TRUE_VALUE
    LD (_alien_exploding),A

    LD A,.ALIEN_EXPLOSION_PERSISTENCE
    LD (_alien_exploding_count_down),A

    LD A,(aliens.alien_count)
    LD L,A
    PUSH HL
    LD HL,(scoring.score_player_1)
    PUSH HL
    CALL alien_missiles.event_player_missile_hit_alien
    POP HL
    POP HL
    
.done
    POP IY,IX,HL,AF

    RET

.ALIEN_EXPLOSION_PERSISTENCE:    EQU 15

event_player_missile_hit_shield:
    ; Inform the player missile that it has hit a shield
    CALL player_missile.event_player_missile_hit_shield 
    
    RET

event_alien_missile_hit_shield:
    CALL alien_missiles.event_alien_missile_hit_shield
    
    RET

event_missile_hit_missile:
.PARAM_ALIEN_MISSILE: EQU 0

    PUSH HL,IX
    
    PARAMS_IX 2                                         ; Get the stack pointer
    
    CALL player_missile.event_missiles_collided
    
    LD HL,(IX+.PARAM_ALIEN_MISSILE)
    PUSH HL
    CALL alien_missiles.event_missiles_collided
    POP HL
    
    POP IX,HL

    RET

event_alien_missile_hit_player:
    PUSH AF

    CALL player.event_alien_missile_hit_player_begin
    CALL player_missile.event_alien_missile_hit_player_begin
    CALL alien_missiles.event_alien_missile_hit_player_begin
    CALL aliens.event_alien_missile_hit_player_begin

    IFNDEF INVINCIBLE
        CALL player_lives.event_alien_missile_hit_player
    ENDIF

    CALL game_screen.draw_bases
    CALL game_screen.print_bases_count

    LD A,40                                             ; TODO This should be configurable
    LD (_life_lost_pause_count_down),A

    LD A,utils.TRUE_VALUE
    LD (_life_lost_pausing),A

.done
    POP AF

    RET

alien_landed_begin:
    PUSH AF

    CALL player.event_alien_landed_begin
    CALL player_missile.event_alien_landed_begin
    CALL alien_missiles.event_alien_landed_begin
    CALL aliens.event_alien_landed_begin

    IFNDEF INVINCIBLE
        CALL player_lives.event_alien_landed_begin
    ENDIF

    CALL game_screen.draw_bases
    CALL game_screen.print_bases_count

    LD A,40                                             ; TODO This should be configurable
    LD (_life_lost_pause_count_down),A

    LD A,utils.TRUE_VALUE
    LD (_life_lost_pausing),A
    LD (_alien_landed),A

.done:  
    POP AF

    RET
