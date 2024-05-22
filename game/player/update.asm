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
    PUSH AF,DE

    ; Read the keyboard
    LD DE,(keyboard.keys_down)

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E                    ; Left pressed?
    JR Z,.left_not_pressed                              ; No

    LD A,(player_x)                                     ; Get current player base X coord
    DEC A                                               ; Decrease it to move left
    CP layout.PLAYER_BASE_MIN_X                         ; Have we hit the left most point?
    JR Z,.done                                          ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E                   ; Right pressed?
    JR Z,.done                                          ; No
    LD A,(player_x)                                     ; Get current player base X coord
    INC A                                               ; Increase it to move right
    CP layout.PLAYER_BASE_MAX_X                         ; Have we hit the right most point?a
    JR NC,.done                                         ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base

.done:
    POP DE,AF

    RET


