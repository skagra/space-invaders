    MODULE player

_PLAYER_Y:              EQU draw.SCREEN_HEIGHT_PIXELS-8*2-1

_player_x:              BLOCK 2


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
    LD (_player_x),A

    LD HL,_bullet_state                         
    LD (HL),_BULLET_STATE_NO_BULLET

    POP AF

    RET

._START_PLAYER_X:       EQU draw.SCREEN_WIDTH_PIXELS/2-8

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
    LD A, (_player_x)                       ; Player base coords
    LD D,A
    LD E, _PLAYER_Y
    PUSH DE

    ; HACK          
    LD DE, 0x0308                           ; Player base dimensions
    PUSH DE

    LD DE,sprites.sprite_base               ; Sprite    
    PUSH DE

    LD DE,sprites.mask_2x8                  ; Sprite mask
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
update_player:
    PUSH AF,DE

    ; Read the keyboard
    LD DE,(keyboard.keys_down)

    ; Update player base position based on keys pressed
    BIT keyboard.LEFT_KEY_DOWN_BIT,E        ; Left pressed?
    JR Z,.left_not_pressed                  ; No

    LD A,(_player_x)                        ; Get current player base X coord
    DEC A                                   ; Decrease it to move left
    CP ._MIN_PLAYER_X                       ; Have we hit the left most point?
    JR Z,.done                              ; Yes so don't update
    LD (_player_x),A                        ; Update the location of the player base
    JR .done

.left_not_pressed
    BIT keyboard.RIGHT_KEY_DOWN_BIT,E       ; Right pressed?
    JR Z,.done                              ; No
    LD A,(_player_x)                        ; Get current player base X coord
    INC A                                   ; Increase it to move right
    CP ._MAX_PLAYER_X                       ; Have we hit the right most point?
    JR NC,.done                             ; Yes so don't update
    LD (_player_x),A                        ; Update the location of the player base

.done:
    POP DE,AF

    RET

._MIN_PLAYER_X:             EQU 0
._MAX_PLAYER_X:             EQU draw.SCREEN_WIDTH_PIXELS-16

blank_bullet:
    PUSH AF,DE

    ; Is there an active bullet to draw?
    LD A,(_bullet_state)
    CP _BULLET_STATE_NO_BULLET
    JR Z,.done

    ; Erase old bullet
    LD A, (_bullet_x)                       ; Player bullet
    LD D,A
    LD A, (_bullet_current_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0204                           ; Player bullet dimensions
    PUSH DE

    LD DE,sprites.sprite_blank_1b_x_4px     ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet      ; Sprite mask  
    PUSH DE

    CALL draw.draw_sprite                   ; Draw the player base sprite

    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET
draw_bullet:
    PUSH AF,DE

    LD A,(_bullet_state)
    CP _BULLET_STATE_ACTIVE
    JR NZ,.done

    ; Draw bullet
    LD A, (_bullet_x)                       ; Player bullet
    LD D,A
    LD A, (_bullet_new_y)
    LD E,A
    PUSH DE

    ; HACK          
    LD DE, 0x0204                           ; Player bullet dimensions
    PUSH DE

    LD DE,sprites.sprite_player_bullet      ; Sprite    
    PUSH DE

    LD DE,sprites.sprite_player_bullet       ; Sprite mask 
    PUSH DE

    CALL draw.draw_sprite                   ; Draw the player base sprite

    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP DE,AF

    RET

_BULLET_STEP_SIZE:          EQU 4
_bullet_state:              BLOCK 1
_BULLET_STATE_NO_BULLET:    EQU 0x00
_BULLET_STATE_ACTIVE:       EQU 0x01
_BULLET_STATE_AT_TOP:       EQU 0x02
_bullet_current_y:          BLOCK 1
_bullet_new_y:              BLOCK 1
_bullet_x:                  BLOCK 1
_BULLET_MIN_Y:              EQU   24

update_bullet:
    PUSH AF,BC,DE,HL

    ; Read the keyboard
    LD DE,(keyboard.keys_down)

    ; Is there a currently active play bullet?
    LD A,(_bullet_state)

    ; Are we already at the top of screen
    CP _BULLET_STATE_AT_TOP
    JR Z,.bullet_at_top 

    CP _BULLET_STATE_ACTIVE
    JR NZ,.no_current_bullet

    ; There is an active bullet so update it

    ; Check whether the bullet has reached to top of the screen
     LD A,(_bullet_current_y)
     CP A,_BULLET_MIN_Y
     JR NC,.continue

     LD A,_BULLET_STATE_AT_TOP
     LD (_bullet_state),A
     LD A,(_bullet_new_y)
     LD (_bullet_current_y),A

     JR .done

.continue
    LD A,(_bullet_new_y)
    LD (_bullet_current_y),A
    LD B,_BULLET_STEP_SIZE   
    SUB B
    LD (_bullet_new_y),A
    
    JR .done

.bullet_at_top:
    LD HL,_bullet_state
    LD (HL),_BULLET_STATE_NO_BULLET
    JR .done

.no_current_bullet
    ; No current bullet - is the fire button down?
    BIT keyboard.FIRE_KEY_DOWN_BIT,E            ; Fire pressed?
    JR Z,.done                                  ; No

    ; Fire pressed - init a new bullet
    LD HL,_bullet_state                         ; We now have an active bullet
    LD (HL),_BULLET_STATE_ACTIVE

    ; Calculate start x coord for bullet
    LD A,(_player_x)
    ADD A,0x04
    LD HL,_bullet_x
    LD (HL),A

    ; Calculate start y coord - set new and current to same values
    LD A,draw.SCREEN_HEIGHT_PIXELS-16    
    LD HL,_bullet_current_y       
    LD (HL),A
    LD HL,_bullet_new_y       
    LD (HL),A

.done
    POP HL,DE,BC,AF

    RET

    ENDMODULE