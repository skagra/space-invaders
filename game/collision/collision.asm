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

_alien_hit_by_player_missile:               BLOCK 2

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
    LD (.collisions),A
    ; <--- Reset collision flags

    ; ---> Player missile collisions 
    LD IX,player_missile_collision

    ; TODO Should we check that the player missile is active here?
    ; Has there been a collision with the player missle?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JP Z,.check_alien_missile_collisions                    ; No collision so done

    ; Did player missile hit an alien?
    LD DE,(IX+COLLISION_OFFSET_COORDS)
    PUSH DE
    PUSH DE                                                 ; Space for return value
    CALL aliens.get_alien_at_coords
    POP DE                                                  ; Return value
    POP HL

    LD A,0xFF                                               ; Did we find a collision with an alien?
    CP D
    JR Z,.check_player_missile_alien_missile_collision      ; No, so done here.

    LD A,(.collisions)                                      ; Record the collision
    OR .PLAYER_MISSILE_HIT_ALIEN_VALUE
    LD (.collisions),A
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
    LD A,(.collisions)                                      ; Record the collision
    OR .PLAYER_MISSILE_HIT_ALIEN_MISSILE_VALUE
    LD (.collisions),A

    JR .check_alien_missile_collisions  

.assume_player_missile_collided_with_shield:
    LD A,(.collisions)                                      ; Assume the collision was with a shield
    OR .PLAYER_MISSILE_HIT_SHIELD_VALUE
    LD (.collisions),A
    ; Fall through

    ; ---> Alien missile collisions (missile to missile collision already checked)
.check_alien_missile_collisions
    LD IX,alien_missile_collision                           ; Point IX at the collision structure
    
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JP Z,.done_checking                                     ; No collision so done

    ; Has current alien missile hit the player
    LD DE,(IX+COLLISION_OFFSET_COORDS)                      ; Target coords
    PUSH DE

    LD A,(player.player_x)                                  ; Coordinates of the player
    LD H,A
    LD A,layout.PLAYER_Y
    LD L,A
 
    LD BC,0x0808
    SUB HL,BC                                               ; Top left   
    PUSH HL

    LD BC,0x1414
    ADD HL,BC                                               ; Bottom right
    PUSH HL

    PUSH HL                                                 ; Space for return value

    CALL utils.is_point_in_box

    POP HL                                                  ; Result
    POP DE
    POP DE
    POP DE

    BIT utils.TRUE_BIT,L
    JR Z,.check_alien_missile_shield_collision

    LD A,(.collisions)                                      ; Assume the collision was with a shield
    OR .ALIEN_MISSILE_HIT_PLAYER_VALUE                      ; LOGPOINT [COLLISION_CHECKS] Player hit but alien missile
    LD (.collisions),A

    JR .done_checking

.check_alien_missile_shield_collision:
    ; TODO Should we check that the alien missile is active here?
    ; Has there been a collision with an alien missile?
    BIT utils.TRUE_BIT,(IX+COLLISION_OFFSET_COLLIDED)
    JR Z,.done_checking                                     ; No collision so done

    LD A,(.collisions)                                      ; Was there a missile to missile collision?
    BIT .PLAYER_MISSILE_HIT_ALIEN_MISSILE_BIT,A             ; Yes - so already dealt with
    JR NZ, .done_checking

    LD A,(.collisions)                                      ; Assume alien missile hit a shield
    OR .ALIEN_MISSILE_HIT_SHIELD_VALUE
    LD (.collisions),A

    JR .done_checking
    ; <---Alien missile collisions

    ; ---> Done check collisions, now decide what to do
.done_checking:
    LD A,(.collisions)
    
    ; Did the player missile hit an alien?
    CP .FIRE_PLAYER_HIT_ALIEN
    JR NZ,.next_1
    LD HL,(_alien_hit_by_player_missile)
    PUSH HL
    CALL global_state.event_player_missile_hit_alien
    POP HL
    ; Fall through

.next_1
    CP .FIRE_PLAYER_HIT_SHIELD
    JR NZ,.next_2
    CALL global_state.event_player_missile_hit_shield 
    ; Fall through

.next_2
    CP .FIRE_ALIEN_HIT_SHIELD
    JR NZ,.next_3
    CALL global_state.event_alien_missile_hit_shield
    ; Fall through

.next_3
    CP .FIRE_MISSILES_COLLIDED
    JR NZ,.next_4
    LD HL,(.alien_missile_hit)
    PUSH HL
    CALL global_state.event_missile_hit_missile
    POP HL
    ; Fall through

.next_4
    ; CP .FIRE_ALIEN_MISSILE_HIT_PLAYER
    BIT .ALIEN_MISSILE_HIT_PLAYER_BIT,A
    JR Z,.next_5
    CALL global_state.event_alien_missile_hit_player

    ; Fall through

.next_5

    POP IX,HL,DE,BC,AF
    
    RET

.collisions:                                BLOCK 1
.alien_missile_hit:                         BLOCK 2

; TODO - Not convinced about this mechanism! Should these be masks?   We have bits that must be true and bits we don't care about?
; Or maybe just one alien bit and one player bit or two separate variables?
.FIRE_PLAYER_HIT_ALIEN:                     EQU .PLAYER_MISSILE_HIT_ALIEN_VALUE
.FIRE_PLAYER_HIT_SHIELD:                    EQU .PLAYER_MISSILE_HIT_SHIELD_VALUE ; & (~ .PLAYER_MISSILE_HIT_ALIEN_VALUE) & (~.PLAYER_MISSILE_HIT_ALIEN_MISSILE_VALUE) 
.FIRE_ALIEN_HIT_SHIELD:                     EQU .ALIEN_MISSILE_HIT_SHIELD_VALUE ; & (~ .PLAYER_MISSILE_HIT_ALIEN_VALUE) & (~.PLAYER_MISSILE_HIT_ALIEN_MISSILE_VALUE) 
.FIRE_MISSILES_COLLIDED:                    EQU .PLAYER_MISSILE_HIT_ALIEN_MISSILE_VALUE ; & (~ .PLAYER_MISSILE_HIT_ALIEN_VALUE)     
.FIRE_ALIEN_MISSILE_HIT_PLAYER:             EQU .ALIEN_MISSILE_HIT_PLAYER_VALUE 

.PLAYER_MISSILE_HIT_ALIEN_VALUE:            EQU 0b00000001
.PLAYER_MISSILE_HIT_SHIELD_VALUE:           EQU 0b00000010
.PLAYER_MISSILE_HIT_ALIEN_MISSILE_VALUE:    EQU 0b00000100
.ALIEN_MISSILE_HIT_SHIELD_VALUE:            EQU 0b00001000
.ALIEN_MISSILE_HIT_PLAYER_VALUE:            EQU 0b00010000

.PLAYER_MISSILE_HIT_ALIEN_BIT:              EQU 0
.PLAYER_MISSILE_HIT_SHIELD_BIT:             EQU 1
.PLAYER_MISSILE_HIT_ALIEN_MISSILE_BIT:      EQU 2
.ALIEN_MISSILE_HIT_SHIELD_BIT:              EQU 3
.ALIEN_MISSILE_HIT_PLAYER_BIT:              EQU 4

   