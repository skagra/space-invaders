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

BOTTOM_GEL_TOP_LEFT_Y:  EQU draw.SCREEN_HEIGHT_CHARS-6
BOTTOM_GEL_HEIGHT:      EQU 5
BASES_GEL_TOP_LEFT_X:   EQU 3
BASES_GEL_TOP_LEFT_Y:   EQU draw.SCREEN_HEIGHT_CHARS-1
BASES_GEL_WIDTH:        EQU 10
BASES_GEL_HEIGHT:       EQU 1
SPACESHIP_GEL_LEFT_Y:   EQU 2
SPACESHIP_GEL_HEIGHT:   EQU 1

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
    LD H,BOTTOM_GEL_TOP_LEFT_Y                                  ; Top left X
    LD L,BOTTOM_GEL_HEIGHT                                      ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                      ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Gren gel covering bases showing remaining lives
    LD H,BASES_GEL_TOP_LEFT_X                                   ; Top left X
    LD L,BASES_GEL_TOP_LEFT_Y                                   ; Top left Y
    PUSH HL
    LD H,BASES_GEL_WIDTH                                        ; Width
    LD L,BASES_GEL_HEIGHT                                       ; Height
    PUSH HL
    LD HL,draw.CA_FG_GREEN                                      ; Green fg attribute
    PUSH HL
    CALL draw.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,SPACESHIP_GEL_LEFT_Y                                   ; Top left X
    LD L,SPACESHIP_GEL_HEIGHT                                   ; Height
    PUSH HL
    LD HL,draw.CA_FG_RED                                        ; Red fg attribute
    PUSH HL
    CALL draw.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Draw static screen labels. 
    LD HL,score_line_0_text
    PUSH HL
    LD HL,0x0000
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,score_line_1_text
    PUSH HL
    LD HL,0x0001
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD HL,lives_and_creds_text
    PUSH HL
    LD HL,draw.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    POP HL

    CALL draw_score_1
    CALL draw_score_2
    CALL draw_high_score
    CALL draw_credit
    CALL draw_bases_count
    CALL draw_reserve_bases

    RET

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

    LD D,RESERVE_BASE_1_X
    LD E,RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    LD D,RESERVE_BASE_2_X
    LD E,RESERVE_BASE_Y
    PUSH DE
    CALL draw_reserve_base
    POP DE

    POP DE

    RET

RESERVE_BASE_Y:     EQU draw.SCREEN_HEIGHT_PIXELS-8-1
RESERVE_BASE_1_X:   EQU 3*8
RESERVE_BASE_2_X:   EQU RESERVE_BASE_1_X+16

DRB_PARAM_COORDS:  EQU 6

draw_reserve_base:
    PUSH DE,IX

    LD  IX,0                                ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+DRB_PARAM_COORDS)             
    PUSH DE     
    ; HACK
    LD DE, 0x0308
    PUSH DE
    LD DE,sprites.sprite_base     
    PUSH DE
    LD DE,sprites.mask_2x16
    PUSH DE
    CALL draw.draw_sprite
    POP DE
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

score_line_0_text:    BYTE " SCORE<1>   HI-SCORE   SCORE<2> ",0
score_line_1_text:    BYTE "   0000      0000        0000   ",0
lives_and_creds_text: BYTE " 3                    CREDIT 00 ",0

    ENDMODULE