init:
    CALL reset

    RET

COLLISION_OFFSET_COLLIDED:  EQU 0
COLLISION_OFFSET_COORDS:    EQU 1
COLLISION_OFFSET_Y_COORD:   EQU 1
COLLISION_OFFSET_X_COORD:   EQU 2
COLLISION_STRUCT_SIZE:      EQU 3

dummy_collision:            BLOCK COLLISION_STRUCT_SIZE
player_missile_collision:   BLOCK COLLISION_STRUCT_SIZE
alien_missile_collision:    BLOCK COLLISION_STRUCT_SIZE

reset:
    PUSH IX

    LD IX,player_missile_collision
    LD (IX+COLLISION_OFFSET_COLLIDED),utils.FALSE_VALUE

    LD IX,alien_missile_collision
    LD (IX+COLLISION_OFFSET_COLLIDED),utils.FALSE_VALUE

    POP IX

    RET

;------------------------------------------------------------------------------
;
; Processes the collision of the player missile with aliens and shields
;
; Usage:
;   CALL handle_collision
;
; Return values:
;   -
;
; Registers modified:
;   -
;
; External state:
;   draw_common.collided - collision flag
;   draw_common.collision_coords - location of the collision (if any)
;      
;------------------------------------------------------------------------------

handle_collision:
    PUSH AF,DE,HL,IX

    LD IX,player_missile_collision

    ; Has there been a collision with the player missle?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JR Z,.check_alien_missile_collision                 ; No collision so done

    ; Did player missile hit an alien?
    LD HL,(IX+COLLISION_OFFSET_COORDS)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL alien_pack.get_alien_at_coords
    POP HL                                              ; Return value
    POP DE

    LD A,0xFF                                           ; Did we find a collision with an alien?
    CP H
    JR Z,.not_hit_an_alien                              ; No, so done here.

    ; Inform the global state engine that the player missile has hit an alien
    PUSH HL
    CALL global_state.event_player_missile_hit_alien
    POP HL
    
    JR .check_alien_missile_collision

.not_hit_an_alien:
    ; Collision was not with an alien - so assume a shield
    CALL global_state.event_player_missile_hit_shield           

.check_alien_missile_collision:
    LD IX,alien_missile_collision

    ; Has there been a collision with an alien missile?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JR Z,.done                                          ; No collision so done

    CALL alien_missiles.event_alien_missile_hit_shield  ; TODO assume a shield for now

.done
    POP IX,HL,DE,AF
    
    RET
