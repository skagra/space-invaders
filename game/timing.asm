    MODULE timing

init:
    RET

delay:

._PARAM_LOOPS:  EQU 8

    PUSH BC,DE,IX

    LD  IX,0                            ; Grab the stack pointer
    ADD IX,SP

    LD DE,(IX+._PARAM_LOOPS)            ; Size of each loop

    LD B,D                              ; Outer loop counter

.outer_loop
    LD C,E                              ; Inner loop counter

.inner_loop
    DEC C
    JR NZ, .inner_loop

    DEC B
    JR NZ, .outer_loop

    POP IX,DE,BC

    RET

;---
; Relies on a bright colour attribute along bottom of screen
; From https://blog.stevewetherill.com/2022/02/odin-computer-graphics-part-two-1986.html
;---
wait_on_end_of_screen:    
    RET

draw_end_of_screen_barrier:

._PARAM_TOP_LEFT:          EQU 8
._PARAM_DIM:               EQU 6

    PUSH HL,IX

    LD  IX,0                            ; Get the stack pointer
    ADD IX,SP

    LD HL,(IX+._PARAM_TOP_LEFT)         ; Top left of rect to fill
    DEC L
    DEC L
    PUSH HL

    LD HL,(IX+._PARAM_DIM)              ; Width and hight of rect to fill
    PUSH HL

    LD HL,40h
    ; IFDEF DEBUG == 0
    ;     LD HL,draw.CA_BRIGHT  
    ; ELSE
    ;     LD HL,draw.CA_BRIGHT  
    ; ENDIF     
    PUSH HL

    CALL draw.fill_screen_attributes_rect

    POP HL
    POP HL
    POP HL

    POP IX,HL

    RET

    ENDMODULE




   
