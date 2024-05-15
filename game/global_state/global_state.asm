init:
    LD A,GAME_STATE_RUNNING
    LD (_game_state),A
    RET

; Global game state taken from GAME_STATE_* values
_game_state: BLOCK 1

GAME_STATE_RUNNING:                 EQU 0b00000001      ; Normal game running state
GAME_STATE_ALIEN_EXPLODING:         EQU 0b00000010      ; An alien has been hit by player missile and is exploding

GAME_STATE_RUNNING_BIT:             EQU 0
GAME_STATE_ALIEN_EXPLODING_BIT:     EQU 1

_alien_exploding_count_down:        BLOCK 1             ; Cycles left to pause while alien explodes

update:
    PUSH AF

    LD A,(_game_state)                                  ; Grab the current game state
    BIT GAME_STATE_ALIEN_EXPLODING_BIT,A                ; Is an alien exploding?
    JR NZ,.state_alien_exploding                        ; Y - handle it
    
    JR .done                                            ; N - all done

.state_alien_exploding                                  ; An alien is exploding
    LD A,(_alien_exploding_count_down)                  ; Reduce cycles left to pause while alien explodes
    DEC A
    LD (_alien_exploding_count_down),A                  
    JR NZ,.done                                         ; Done exploding? N then done.
    
    ; Alien done exploding
    CALL alien_pack.event_alien_explosion_done          ; Inform the alien pack  
    CALL player_missile.event_alien_explosion_done      ; Inform the player missile
    
    LD A,GAME_STATE_RUNNING                             ; Update global state to nominal running
    LD (_game_state),A

.done
    POP AF

    RET

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
    CALL alien_pack.event_alien_hit_by_player_missile
    POP HL

    ; Inform scoring 
    LD IY,HL
    LD HL,(IY+alien_pack._STATE_OFFSET_TYPE)                                      
    PUSH HL
    CALL scoring.event_alien_hit_by_player_missile
    POP HL

    ; Set global state to indicate an alien is exploding
    LD A,GAME_STATE_ALIEN_EXPLODING
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
