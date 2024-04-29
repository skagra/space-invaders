    MODULE game_screen

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
; Draw the initial screen.
; 
; Usage:
;   CALL init_screen
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

init_screen:
    PUSH HL

    ; Clear the screen
    call draw.wipe_screen

    ; Fill screen with black bg, white fg
    LD L,draw.CA_BG_BLACK | draw.CA_FG_WHITE
    PUSH HL
    CALL draw.fill_screen_attributes
    POP HL

    ; Green gel to cover active player base and defences
    LD H,._BOTTOM_GEL_TOP_LEFT_Y                                    ; Top left X
    LD L,._BOTTOM_GEL_HEIGHT                                        ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                          ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Gren gel covering bases showing remaining lives
    LD H,._BASES_GEL_TOP_LEFT_X                                     ; Top left X
    LD L,._BASES_GEL_TOP_LEFT_Y                                     ; Top left Y
    PUSH HL
    LD H,._BASES_GEL_WIDTH                                          ; Width
    LD L,._BASES_GEL_HEIGHT                                         ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                          ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,._SPACESHIP_GEL_LEFT_Y                                     ; Top left X
    LD L,._SPACESHIP_GEL_HEIGHT                                     ; Height
    PUSH HL
    LD HL,draw.CA_FG_RED                                            ; Red fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Draw static screen labels. 
    LD HL,._SCORE_LINE_0_TEXT
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,._SCORE_LINE_1_TEXT
    PUSH HL
    LD HL,0x0001
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,._LIVES_AND_CREDS_TEXT
    PUSH HL
    LD HL,draw.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    CALL draw_shields

    POP HL

    CALL draw_score_1
    CALL draw_score_2
    CALL draw_high_score
    CALL draw_credit
    CALL draw_bases_count
    CALL draw_reserve_bases

    RET

._BOTTOM_GEL_TOP_LEFT_Y:    EQU draw.SCREEN_HEIGHT_CHARS-6
._BOTTOM_GEL_HEIGHT:        EQU 5
._BASES_GEL_TOP_LEFT_X:     EQU 3
._BASES_GEL_TOP_LEFT_Y:     EQU draw.SCREEN_HEIGHT_CHARS-1
._BASES_GEL_WIDTH:          EQU 10
._BASES_GEL_HEIGHT:         EQU 1
._SPACESHIP_GEL_LEFT_Y:     EQU 2
._SPACESHIP_GEL_HEIGHT:     EQU 1

._SCORE_LINE_0_TEXT:        BYTE " SCORE<1>   HI-SCORE   SCORE<2> ",0
._SCORE_LINE_1_TEXT:        BYTE "   0000      0000        0000   ",0
._LIVES_AND_CREDS_TEXT:     BYTE " 3                    CREDIT 00 ",0

; TODO
draw_score_1:
    RET

; TODO
draw_score_2:
    RET

; TODO
draw_high_score:
    RET

; TODO
draw_credit:
    RET
    
; TODO
draw_bases_count:
    RET

; TODO
draw_reserve_bases:
    PUSH DE

    LD D,._RESERVE_BASE_1_X
    LD E,._RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    LD D,._RESERVE_BASE_2_X
    LD E,._RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    POP DE

    RET

._RESERVE_BASE_Y:     EQU draw.SCREEN_HEIGHT_PIXELS-8-1
._RESERVE_BASE_1_X:   EQU 3*8
._RESERVE_BASE_2_X:   EQU ._RESERVE_BASE_1_X+16

draw_reserve_base:

._PARAM_COORDS:  EQU 6

    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+._PARAM_COORDS)             
    PUSH DE     
    ; HACK
    LD DE, 0x0308
    PUSH DE
    LD DE,sprites.sprite_base     
    PUSH DE
    LD DE,sprites.mask_2x8
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

draw_shields:
    PUSH DE

    LD D,._SHIELD_1_X
    LD E,._SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    LD D,._SHIELD_2_X
    LD E,._SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    LD D,._SHIELD_3_X
    LD E,._SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    POP DE

    RET

._SHIELD_1_X:       EQU 50
._SHIELD_2_X:       EQU draw.SCREEN_WIDTH_PIXELS/2-(22/2)
._SHIELD_3_X:       EQU draw.SCREEN_WIDTH_PIXELS-50-(22/2)
._SHIELD_Y:         EQU draw.SCREEN_HEIGHT_PIXELS-8*5

draw_shield:

._PARAM_COORDS:  EQU 6

    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+._PARAM_COORDS)             
    PUSH DE     
    ; HACK
    LD DE, 0x0410
    PUSH DE
    LD DE,sprites.sprite_shield     
    PUSH DE
    LD DE,sprites.sprite_shield
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET



    ENDMODULE