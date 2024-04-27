    MODULE player

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

draw_player:
    ; Draw the player base sprite
    LD A, (player_x)                        ; Player base coords
    LD D,A
    LD E, PLAYER_Y
    PUSH DE

    ; HACK          
    LD DE, 0x0308                           ; Player base dimensions
    PUSH DE

    LD DE,sprites.sprite_base               ; Sprite    
    PUSH DE

    LD DE,sprites.mask_2x16                 ; Sprite mask
    PUSH DE

    CALL draw.draw_sprite                   ; Draw the player base sprite
    POP DE
    POP DE
    POP DE
    POP DE

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

process_player:
    PUSH AF,DE

    ; Read the keyboard
    PUSH DE                                 ; Allocate space on stack for return value
    CALL keyboard.get_movement_keys
    POP DE                                  ; Keys pressed

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E        ; Left pressed?
    JR Z,.left_not_pressed                  ; No

    LD A,(player_x)                         ; Get current player base X coord
    DEC A                                   ; Decrease it to move left
    CP MIN_PLAYER_X                         ; Have we hit the left most point?
    JR Z,.done                              ; Yes so don't update
    LD (player_x),A                         ; Update the location of the player base
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E       ; Right pressed?
    JR Z,.done                              ; No
    LD A,(player_x)                         ; Get current player base X coord
    INC A                                   ; Increase it to move right
    CP MAX_PLAYER_X                         ; Have we hit the right most point?
    JR NC,.done                             ; Yes so don't update
    LD (player_x),A                         ; Update the location of the player base

.done:
    POP DE,AF

    RET

player_x:       BYTE draw.SCREEN_WIDTH_PIXELS/2-8
PLAYER_Y:       EQU draw.SCREEN_HEIGHT_PIXELS-8*2-1
MIN_PLAYER_X:   EQU 0
MAX_PLAYER_X:   EQU draw.SCREEN_WIDTH_PIXELS-16

    ENDMODULE