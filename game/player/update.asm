;------------------------------------------------------------------------------
;
; Read the keyboard and move the player base based on key presses.
; 
; Usage:
;   CALL process_player
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

update:
    PUSH AF,DE,HL

    LD A,(_player_state)

    BIT _PLAYER_STATE_ACTIVE_BIT,A
    JR NZ,.active

    BIT _PLAYER_STATE_EXPLODING_BIT,A
    JR NZ,.exploding

    BIT _PLAYER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.done_exploding

    ; ASSERT This point should never be reached

    JR .done

.active
    ; Read the keyboard
    LD DE,(keyboard.keys_down)

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E                    ; Left pressed?
    JR Z,.left_not_pressed                              ; No

    LD A,(player_x)                                     ; Get current player base X coord
    DEC A                                               ; Decrease it to move left
    CP layout.PLAYER_MIN_X                              ; Have we hit the left most point?
    JR Z,.done                                          ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base
    
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E                   ; Right pressed?
    JR Z,.done                                          ; No
    LD A,(player_x)                                     ; Get current player base X coord
    INC A                                               ; Increase it to move right
    CP layout.PLAYER_MAX_X                              ; Have we hit the right most point?a
    JR NC,.done                                         ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base

    JR .done

.exploding:
    LD A,(_player_explosion_variant_cycle_count)
    DEC A
    LD (_player_explosion_variant_cycle_count),A
    JR NZ,.done

    LD A,_PLAYER_EXPLOSION_VARIANT_SWITCH_MAX
    LD (_player_explosion_variant_cycle_count),A

    LD DE,sprites.PLAYER_EXPLOSION_VARIANT_0
    LD HL,(_player_explosion_variant_sprite)
    SUB HL,DE
    JR Z,.switch_to_variant_1

    LD DE,sprites.PLAYER_EXPLOSION_VARIANT_0
    LD HL,_player_explosion_variant_sprite
    LD (HL),DE

    JR .done

.switch_to_variant_1:
    LD DE,sprites.PLAYER_EXPLOSION_VARIANT_1
    LD HL,_player_explosion_variant_sprite
    LD (HL),DE

    JR .done

.done_exploding:
    LD A,_PLAYER_STATE_ACTIVE_VALUE
    LD (_player_state),A

    JR .done

.done:
    POP HL,DE,AF

    RET


