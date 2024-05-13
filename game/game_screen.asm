    MODULE game_screen

_module_start:

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

    ; Make the screen black until we've drawn some inital content
    LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_BLACK
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    ; Set the screen border
    LD HL,draw_common.BORDER_BLACK
    PUSH HL
    CALL draw_common.set_border    
    POP HL

    ; Clear the screen
    call draw_common.wipe_screen

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
    LD HL,draw_common.SCREEN_HEIGHT_CHARS-1
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    CALL draw_horiz_line
    CALL draw_score_1
    CALL draw_score_2
    CALL draw_high_score
    CALL draw_credit
    CALL draw_bases_count
    CALL draw_reserve_bases
    CALL draw_shields

    ; Fill screen with black bg, white fg
    LD L,draw_common.CA_BG_BLACK | draw_common.CA_FG_WHITE
    PUSH HL
    CALL draw_common.fill_screen_attributes
    POP HL

    ; Green gel to cover active player base and defences
    LD H,._BOTTOM_GEL_TOP_LEFT_Y                        ; Top left X
    LD L,._BOTTOM_GEL_HEIGHT                            ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_GREEN                       ; Green fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attribute_stripe
    POP HL
    POP HL

    ; Green gel covering bases showing remaining lives
    LD H,._BASES_GEL_TOP_LEFT_X                         ; Top left X
    LD L,._BASES_GEL_TOP_LEFT_Y                         ; Top left Y
    PUSH HL
    LD H,._BASES_GEL_WIDTH                              ; Width
    LD L,._BASES_GEL_HEIGHT                             ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_GREEN                       ; Green fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attributes_rect
    POP HL
    POP HL
    POP HL

    ; Red gel just below scores - for spaceship and exploding player missiles
    LD H,._SPACESHIP_GEL_LEFT_Y                         ; Top left X
    LD L,._SPACESHIP_GEL_HEIGHT                         ; Height
    PUSH HL
    LD HL,draw_common.CA_FG_RED                         ; Red fg attribute
    PUSH HL
    CALL draw_common.fill_screen_attribute_stripe
    POP HL
    POP HL

    POP HL

    RET

._BOTTOM_GEL_TOP_LEFT_Y:    EQU draw_common.SCREEN_HEIGHT_CHARS-5
._BOTTOM_GEL_HEIGHT:        EQU 4
._BASES_GEL_TOP_LEFT_X:     EQU 3
._BASES_GEL_TOP_LEFT_Y:     EQU draw_common.SCREEN_HEIGHT_CHARS-1
._BASES_GEL_WIDTH:          EQU 10
._BASES_GEL_HEIGHT:         EQU 1
._SPACESHIP_GEL_LEFT_Y:     EQU 2
._SPACESHIP_GEL_HEIGHT:     EQU 1

._SCORE_LINE_0_TEXT:        BYTE "   SCORE<1> HI-SCORE SCORE<2>",0
._SCORE_LINE_1_TEXT:        BYTE "     0000    0000      0000  ",0
._LIVES_AND_CREDS_TEXT:     BYTE "   3                CREDIT 00",0

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

._RESERVE_BASE_Y:     EQU draw_common.SCREEN_HEIGHT_PIXELS-8-1
._RESERVE_BASE_1_X:   EQU layout.INSET_X_PIXELS+3*8
._RESERVE_BASE_2_X:   EQU ._RESERVE_BASE_1_X+((sprites.PLAYER_BASE_DIM_X_BYTES-1)*8)

draw_reserve_base:

.PARAM_COORDS:  EQU 6

    PUSH DE,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+.PARAM_COORDS)             
    PUSH DE     

    LD DE,sprites.PLAYER_BASE_DIMS
    PUSH DE
    LD DE,sprites.PLAYER_BASE     
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
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

    LD D,._SHIELD_4_X
    LD E,._SHIELD_Y
    PUSH DE
    CALL draw_shield
    POP DE

    POP DE

    RET

._SHIELD_WIDTH_PIXELS:  EQU (sprites.SHIELD_DIM_X_BYTES-1)*8
._SCREEN_X_MIDDLE:      EQU (layout.INSET_SCREEN_WIDTH_PIXELS/2)+layout.INSET_X_PIXELS;

._SHIELD_1_X:           EQU ._SCREEN_X_MIDDLE-3*._SHIELD_WIDTH_PIXELS-._SHIELD_WIDTH_PIXELS/2
._SHIELD_2_X:           EQU ._SCREEN_X_MIDDLE-1*._SHIELD_WIDTH_PIXELS-._SHIELD_WIDTH_PIXELS/2
._SHIELD_3_X:           EQU ._SCREEN_X_MIDDLE+1*._SHIELD_WIDTH_PIXELS-._SHIELD_WIDTH_PIXELS/2
._SHIELD_4_X:           EQU ._SCREEN_X_MIDDLE+3*._SHIELD_WIDTH_PIXELS-._SHIELD_WIDTH_PIXELS/2
._SHIELD_Y:             EQU draw_common.SCREEN_HEIGHT_PIXELS-8*5

draw_shield:

.PARAM_COORDS:  EQU 6

    PUSH DE,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  

    LD DE,(IX+.PARAM_COORDS)             
    PUSH DE     
    LD DE,sprites.SHIELD_DIMS
    PUSH DE
    LD DE,sprites.SHIELD     
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
    POP DE
    POP DE
    POP DE

    POP IX,DE

    RET

draw_horiz_line:
    PUSH AF,BC,DE,HL

    LD B,layout.INSET_X_PIXELS
    LD C,.HORIZ_LINE_Y

    LD L,layout.INSET_SCREEN_WIDTH_CHARS

.loop       
    PUSH BC 
    LD DE,sprites.HORIZ_LINE_DIMS
    PUSH DE
    LD DE,sprites.HORIZ_LINE    
    PUSH DE
    CALL draw.draw_sprite_and_flush_buffer
    POP DE
    POP DE
    POP DE

    LD A,0x08
    ADD A,B
    LD B,A

    DEC L
    JR NZ,.loop

    POP HL,DE,BC,AF

    RET

.HORIZ_LINE_Y: EQU draw_common.SCREEN_HEIGHT_PIXELS-10

    MEMORY_USAGE "game screen     ",_module_start
    
    ENDMODULE