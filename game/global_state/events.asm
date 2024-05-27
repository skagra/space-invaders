event_player_missile_hit_alien:

.PARAM_TARGET_ALIEN: EQU 10                       
    
    PUSH AF,HL,IX,IY

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  

    ; Inform the player missile 
    CALL player_missile.event_player_missile_hit_alien

    ; Inform the alien pack 
    LD HL,(IX+.PARAM_TARGET_ALIEN)
    PUSH HL
    CALL aliens.event_alien_hit_by_player_missile
    POP HL

    ; Inform scoring 
    LD IY,HL
    LD HL,(IY+aliens._STATE_OFFSET_TYPE)                                      
    PUSH HL
    CALL scoring.event_alien_hit_by_player_missile
    POP HL

    ; Draw the player's score                           ; TODO - Maybe this should be sending an event?
    CALL game_screen.print_score_player_1 

    ; Set global state to indicate an alien is exploding
    LD A,_GAME_STATE_ALIEN_EXPLODING_VALUE
    LD (_game_state),A
    LD A,.ALIEN_EPLOSION_PERSISTENCE
    LD (_alien_exploding_count_down),A

    POP IY,IX,HL,AF

    RET

.ALIEN_EPLOSION_PERSISTENCE:    EQU 15

event_player_missile_hit_shield:

    ; Inform the player missile that it has hit a shield
    CALL player_missile.event_player_missile_hit_shield 
    
    RET

event_alien_missile_hit_shield:
    CALL alien_missiles.event_alien_missile_hit_shield
    
    RET

event_missile_hit_missile:
.PARAM_ALIEN_MISSILE: EQU 4
    PUSH HL
    
    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  
    
    CALL player_missile.event_missiles_collided
    
    LD HL,(IX+.PARAM_ALIEN_MISSILE)
    PUSH HL
    CALL alien_missiles.event_missiles_collided
    POP HL
    
    POP HL

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

    LD A,240                                             ; TODO
    LD (_life_lost_pause_count_down),A

    LD A,_GAME_STATE_LIFE_LOST_PAUSING_VALUE
    LD (_game_state),A

    ; LD A,(player_lives.player_lives_1)                ; Game over?
    ; AND A
    ; JR NZ,.done

    ; LD A,_GAME_STATE_GAME_OVER_VALUE
    ; LD (_game_state),A
    ; CALL game_screen.print_game_over
    
.done
    POP AF


    RET


