    MODULE player

_module_start:

PLAYER_Y:               EQU draw_common.SCREEN_HEIGHT_PIXELS-20
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

    LD A,._START_PLAYER_X
    LD (player_x),A

    POP AF

    RET

._START_PLAYER_X:       EQU (draw_common.SCREEN_WIDTH_PIXELS/2)-((sprites.PLAYER_BASE_DIM_X_BYTES-1)*8)/2 ; Middle of screen offset by half the width of the base

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
    PUSH AF,DE

    ; Draw the player base sprite
    LD A, (player_x)                                    ; Player base coords
    LD D,A
    LD E, PLAYER_Y
    PUSH DE
      
    LD DE,sprites.PLAYER_BASE                           ; Sprite    
    PUSH DE

    CALL fast_draw.fast_draw_sprite_16x8                ; Draw the player base sprite
    
    POP DE
    POP DE

    POP DE,AF

    RET

blank_player:
    PUSH AF,DE

    ; Erase the player base sprite
    LD A, (player_x)                                    ; Coords
    LD D,A
    LD E, PLAYER_Y
    PUSH DE

    LD DE,sprites.PLAYER_BASE_BLANK                     ; Sprite    
    PUSH DE

    CALL fast_draw.fast_draw_sprite_16x8                ; Draw the player base sprite

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
update_player:
    PUSH AF,DE

    ; Read the keyboard
    LD DE,(keyboard.keys_down)

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E                    ; Left pressed?
    JR Z,.left_not_pressed                              ; No

    LD A,(player_x)                                     ; Get current player base X coord
    DEC A                                               ; Decrease it to move left
    CP ._MIN_PLAYER_X                                   ; Have we hit the left most point?
    JR Z,.done                                          ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E                   ; Right pressed?
    JR Z,.done                                          ; No
    LD A,(player_x)                                     ; Get current player base X coord
    INC A                                               ; Increase it to move right
    CP ._MAX_PLAYER_X                                   ; Have we hit the right most point?a
    JR NC,.done                                         ; Yes so don't update
    LD (player_x),A                                     ; Update the location of the player base

.done:
    POP DE,AF

    RET

._MIN_PLAYER_X:             EQU layout.INSET_X_PIXELS
._MAX_PLAYER_X:             EQU layout.INSET_X_PIXELS+layout.INSET_SCREEN_WIDTH_PIXELS-(sprites.PLAYER_BASE_DIM_X_BYTES-1)*8

    MEMORY_USAGE "player          ",_module_start

    ENDMODULE