player_x:               BLOCK 1

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
;------------------------------------------------------------------------------

init:
    PUSH AF

    LD A,layout.PLAYER_BASE_START_X
    LD (player_x),A

    POP AF

    RET

;------------------------------------------------------------------------------
;
; Draw the player base
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

draw:
    PUSH AF,DE

    ; Draw the player base sprite
    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, layout.PLAYER_BASE_Y
    PUSH DE
      
    LD DE,sprites.PLAYER_BASE                           ; Sprite    
    PUSH DE

    LD E,utils.FALSE_VALUE
    PUSH DE ; xxx
    CALL fast_draw.draw_sprite_16x8                     ; Draw the player base sprite
    POP DE ; xxx

    POP DE
    POP DE

    POP DE,AF

    RET

blank:
    PUSH AF,DE

    ; Erase the player base sprite
    LD A, (player_x)                                    ; Coords
    LD D,A
    LD E, layout.PLAYER_BASE_Y
    PUSH DE

    LD DE,sprites.PLAYER_BASE                           ; Sprite    
    PUSH DE

    LD E,utils.TRUE_VALUE
    PUSH DE ;xxx
    CALL fast_draw.draw_sprite_16x8                     ; Erase the player base sprite
    POP DE ; xxx
    
    POP DE
    POP DE

    POP DE,AF

    RET

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


