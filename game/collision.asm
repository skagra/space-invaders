    MODULE collision

_module_start:

init:
    RET

; Pass in coords
handle_collision:
    PUSH AF,DE,HL

    ; Has there been a collision with the player missle?
    LD A,(draw_common.collided)
    BIT 0,A
    JR Z,.done

    ; Did player missile hit an alien?
    LD HL,(draw_common.collision_coords)
    PUSH HL
    PUSH HL                                             ; Space for return value
    CALL alien_pack.get_alien_at_coords
    POP HL                                              ; Return value
    POP DE

    LD A,0xFF                                           ; Did we find a collision with an alien?
    CP H
    JR Z,.not_hit_an_alien                              ; No so done.

    ; Flag to the alien pack that an alien has been hit by the player missile
    PUSH HL
    CALL alien_pack.alien_hit_by_player_missile
    POP HL

    CALL player_bullet.bullet_hit_alien

    JR .done

.not_hit_an_alien:
    CALL player_bullet.bullet_hit_a_shield

.done
    POP   HL,DE,AF
    
    RET

    MEMORY_USAGE "collision       ",_module_start

    ENDMODULE