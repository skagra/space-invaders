init:
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
    PUSH AF,DE,HL

    ; Has there been a collision with the player missle?
    LD A,(draw_common.collided)
    BIT utils.TRUE_BIT,A
    JR Z,.done                                          ; No collision so done

    ; Did player missile hit an alien?
    LD HL,(draw_common.collision_coords)
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
    
    JR .done

.not_hit_an_alien:
    ; Collision was not with an alien - so assume a shield
    CALL global_state.event_player_missile_hit_shield           

.done
    POP HL,DE,AF
    
    RET
