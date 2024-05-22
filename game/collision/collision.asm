init:
    CALL reset

    RET

COLLISION_OFFSET_COLLIDED:      EQU 0
COLLISION_OFFSET_COORDS:        EQU 1
COLLISION_OFFSET_Y_COORD:       EQU 1
COLLISION_OFFSET_X_COORD:       EQU 2
COLLISION_OFFSET_CLIENT_DATA:   EQU 3

COLLISION_STRUCT_SIZE:          EQU 5

dummy_collision:                BLOCK COLLISION_STRUCT_SIZE
player_missile_collision:       BLOCK COLLISION_STRUCT_SIZE
alien_missile_collision:        BLOCK COLLISION_STRUCT_SIZE

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

_player_missile_hit_alien_value:            EQU 0b00000001
_player_missile_hit_shield_value:           EQU 0b00000010
_player_missile_hit_alien_missile_value:    EQU 0b00000100
_alien_missile_hit_shield_value:            EQU 0b00001000

_player_missile_hit_alien_bit:              EQU 0
_player_missile_hit_shield_bit:             EQU 1
_player_missile_hit_alien_missile_bit:      EQU 2
_alien_missile_hit_shield_bit:              EQU 3

_collisions:                                BLOCK 1

_alien_hit_by_player_missile:               BLOCK 2

_fire_player_hit_alien:                     EQU _player_missile_hit_alien_value
_fire_player_hit_shield:                    EQU _player_missile_hit_shield_value & (~ _player_missile_hit_alien_value) & (~_player_missile_hit_alien_missile_value)
_fire_alien_hit_shield:                     EQU _alien_missile_hit_shield_value & (~ _player_missile_hit_alien_value) & (~_player_missile_hit_alien_missile_value)
_fire_missiles_collided:                    EQU _player_missile_hit_alien_missile_value & (~ _player_missile_hit_alien_value)                    


    MACRO CHECK_ALIEN_MISSILE am_number
    
        LD A,utils.FALSE_VALUE                                  ; Not a match (yet)

        LD IY,alien_missiles._ALIEN_MISSILE_am_number           ; Alien missile under test

        ; Check the alien missile is active
        BIT alien_missiles._ALIEN_MISSILE_STATE_ACTIVE_BIT,(IY+alien_missiles._ALIEN_MISSILE_OFFSET_STATE)
        JR Z,.not_this_alien_missile

        LD DE,(IX+COLLISION_OFFSET_COORDS)                      ; Target coords
        PUSH DE 

        LD HL,(IY+alien_missiles._ALIEN_MISSILE_OFFSET_COORDS)  ; Top Left
        LD BC,0x0804                                            
        SUB HL,BC
        PUSH HL

        LD BC,0x100C                                            ; Bottom right 
        ADD HL,BC
        PUSH HL

        PUSH HL                                                 ; Space for return value

        CALL utils.is_point_in_box

        POP HL                                                  ; Result
        POP BC
        POP BC
        POP BC

        LD A,L

.not_this_alien_missile

    ENDM

handle_collision:
    PUSH AF,BC,DE,HL,IX

    ; ---> Reset collision flags
    LD A,0x00
    LD (_collisions),A
    ; <--- Reset collision flags

    ; ---> Player missile collisions 
    LD IX,player_missile_collision

    ; TODO CHECK ACTIVE HERE?
    ; Has there been a collision with the player missle?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JP Z,.check_alien_missile_collisions                    ; No collision so done

    ; Did player missile hit an alien?
    LD DE,(IX+COLLISION_OFFSET_COORDS)
    PUSH DE
    PUSH DE                                                 ; Space for return value
    CALL alien_pack.get_alien_at_coords
    POP DE                                                  ; Return value
    POP HL

    LD A,0xFF                                               ; Did we find a collision with an alien?
    CP D
    JR Z,.check_player_missile_alien_missile_collision      ; No, so done here.

    LD A,(_collisions)                                      ; Record the collision
    OR _player_missile_hit_alien_value
    LD (_collisions),A
    LD HL,_alien_hit_by_player_missile
    LD (HL),DE
    
    JP .check_alien_missile_collisions                      ; Player missile has hit an alien so skip other player missile checks

.check_player_missile_alien_missile_collision:
    CHECK_ALIEN_MISSILE 0
    BIT utils.TRUE_BIT,A
    JR Z,.not_alien_missile_0
    LD HL,alien_missiles._ALIEN_MISSILE_0                   ; LOGPOINT [COLLISION_CHECKS] Missile hit missile 0
    LD (.alien_missile_hit),HL                              
    JR .alien_missile_found

.not_alien_missile_0:
    CHECK_ALIEN_MISSILE 1
    BIT utils.TRUE_BIT,A
    JR Z,.not_alien_missile_1
    LD HL,alien_missiles._ALIEN_MISSILE_1                   ; LOGPOINT [COLLISION_CHECKS] Missile hit missile 1
    LD (.alien_missile_hit),HL
    JR .alien_missile_found

.not_alien_missile_1:
    CHECK_ALIEN_MISSILE 2
    BIT utils.TRUE_BIT,A
    JR Z,.assume_player_missile_collided_with_shield        ; LOGPOINT [COLLISION_CHECKS] Missile hit missile 2
    LD HL,alien_missiles._ALIEN_MISSILE_2
    LD (.alien_missile_hit),HL
    ; Fall through

.alien_missile_found:
    LD A,(_collisions)                                  ; Record the collision
    OR _player_missile_hit_alien_missile_value
    LD (_collisions),A

    JR .check_alien_missile_collisions  

.assume_player_missile_collided_with_shield:
    LD A,(_collisions)                                  ; Assume the collision was with a shield
    OR _player_missile_hit_shield_value
    LD (_collisions),A
    ; Fall through

    ; ---> Alien missile collisions (missile to missile collision already checked)
.check_alien_missile_collisions
    LD IX,alien_missile_collision

    ; Has there been a collision with an alien missile?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JR Z,.done_checking                                 ; No collision so done

    LD A,(_collisions)                                  ; Was there a missile to missile collision?
    BIT _player_missile_hit_alien_missile_bit,A         ; Yes - so already dealt with
    JR NZ, .done_checking

    LD A,(_collisions)                                  ; Assume alien missile hit a shield
    OR _alien_missile_hit_shield_value
    LD (_collisions),A

    JR .done_checking
    ; <---Alien missile collisions

    ; ---> Done check collisions, now decide what to do
.done_checking:
    LD A,(_collisions)
    
    ; Did the player missile hit an alien?
    CP _fire_player_hit_alien
    JR NZ,.next_1
    LD HL,(_alien_hit_by_player_missile)
    PUSH HL
    CALL global_state.event_player_missile_hit_alien
    POP HL
    ; Fall through

.next_1
    CP _fire_player_hit_shield
    JR NZ,.next_2
    CALL global_state.event_player_missile_hit_shield 
    ; Fall through

.next_2
    CP _fire_alien_hit_shield
    JR NZ,.next_3
    CALL global_state.event_alien_missile_hit_shield
    ; Fall through

.next_3
    CP _fire_missiles_collided
    JR NZ,.next_4
    LD HL,(.alien_missile_hit)
    PUSH HL
    CALL global_state.event_missile_hit_missile
    POP HL
    ; Fall through

.next_4

    ; LOGPOINT [COLLISION_CHECKS] _player_missile_hit_alien=${(collision._player_missile_hit_alien)}
    ; LOGPOINT [COLLISION_CHECKS] _player_missile_hit_alien_missile=${(collision._player_missile_hit_alien_missile)}
    ; LOGPOINT [COLLISION_CHECKS] _player_missile_hit_shield=${(collision._player_missile_hit_shield)}
    ; LOGPOINT [COLLISION_CHECKS] _alien_missile_hit_shield=${(collision._alien_missile_hit_shield)}

    POP IX,HL,DE,BC,AF
    
    RET
.alien_missile_hit: BLOCK 2


   