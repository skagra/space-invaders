COLLISION_OFFSET_COLLIDED:      EQU 0
COLLISION_OFFSET_COORDS:        EQU 1
COLLISION_OFFSET_Y_COORD:       EQU 1
COLLISION_OFFSET_X_COORD:       EQU 2
COLLISION_OFFSET_CLIENT_DATA:   EQU 3

COLLISION_STRUCT_SIZE:          EQU 5

dummy_collision:                BLOCK COLLISION_STRUCT_SIZE
player_missile_collision:       BLOCK COLLISION_STRUCT_SIZE
alien_missile_collision:        BLOCK COLLISION_STRUCT_SIZE