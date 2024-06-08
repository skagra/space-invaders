;------------------------------------------------------------------------------
;
; Initialise the module
; 
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

init:
    RET

new_sheet:
    PUSH AF,HL

    ; Start will the first missile
    LD HL,_current_alien_missile_ptr
    LD DE,_ALIEN_MISSILE_0
    LD (HL),DE

    ; Enable missile firing
    LD A,utils.TRUE_VALUE
    LD (_enabled),A

    ; Set missile delta
    LD A,_MISSILE_DELTA_Y_NOMINAL
    LD (_missile_delta),A

    ; Copy initialization values into active values
    LD HL,_ALIEN_MISSILE_0_INIT
    PUSH HL
    LD HL,_ALIEN_MISSILE_0
    PUSH HL
    LD HL,_ALIEN_MISSILE_STRUCT_SIZE
    PUSH HL
    CALL utils.copy_mem
    POP HL
    POP HL
    POP HL
    
    LD HL,_ALIEN_MISSILE_1_INIT
    PUSH HL
    LD HL,_ALIEN_MISSILE_1
    PUSH HL
    LD HL,_ALIEN_MISSILE_STRUCT_SIZE
    PUSH HL
    CALL utils.copy_mem
    POP HL
    POP HL
    POP HL

    LD HL,_ALIEN_MISSILE_2_INIT
    PUSH HL
    LD HL,_ALIEN_MISSILE_2
    PUSH HL
    LD HL,_ALIEN_MISSILE_STRUCT_SIZE
    PUSH HL
    CALL utils.copy_mem
    POP HL
    POP HL
    POP HL

    LD A,(_RELOAD_RATES)
    LD (_reload_rate),A

    LD A,utils.TRUE_VALUE
    LD (_missile_1_enabled),A

    LD A,0x00
    LD (_seeker_missile_toggle),A
    
    POP HL,AF

    RET




