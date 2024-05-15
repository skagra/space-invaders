init:
    LD A,GAME_STATE_RUNNING
    RET

_game_state: BYTE 1

GAME_STATE_RUNNING:                 EQU 0b00000001
GAME_STATE_ALIEN_EXPLODING:         EQU 0b00000010

GAME_STATE_RUNNING_BIT:             EQU 0
GAME_STATE_ALIEN_EXPLODING_BIT:     EQU 1

_alien_exploding_count_down:        BYTE 1

update_global_state:
    PUSH AF

    LD A,(_game_state)
    BIT GAME_STATE_ALIEN_EXPLODING_BIT,A
    JR NZ,.state_alien_exploding

.state_alien_exploding
    LD A,(_alien_exploding_count_down)
    DEC A
    LD (_alien_exploding_count_down),A
    JR NZ,.done
    
    CALL alien_pack.event_alien_explosion_done
    CALL player_missile.event_alien_explosion_done
    
    LD A,GAME_STATE_RUNNING
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
    LD A,15                                             ;TODO
    LD (_alien_exploding_count_down),A

    POP IY,IX,HL,AF

    RET

event_player_missile_hit_shield:

    ; Inform the player missile that it has hit a shield
    CALL player_missile.event_player_missile_hit_shield 
    
    RET
