    MODULE double_buffer

init:
    PUSH HL

    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL

    RET

;------------------------------------------------------------------------------
; Draw a sprite and flush the double buffer to the screen
;
; Usage:
;   PUSH coords word - X high byte, Y low byte
;   PUSH dimensions word - X dim high byte, Y dim low byte
;   PUSH address of pre-shifted sprite lookup table
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------

draw_sprite_and_flush_buffer:

._PARAM_COORDS:            EQU 10       ; Sprite coordinates
._PARAM_DIMS:              EQU 8        ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 6        ; Sprite pre-shifted data lookup table
    
    PUSH HL,IX

    LD  IX,0                            ; Point IX to the stack
    ADD IX,SP                                                   

    LD HL,(IX+._PARAM_COORDS)
    PUSH HL
    LD HL,(IX+._PARAM_DIMS)
    PUSH HL
    LD HL,(IX+._PARAM_SPRITE_DATA)
    PUSH HL

    CALL draw.draw_sprite

    POP HL
    POP HL
    POP HL

    CALL copy_buffer_to_screen

    POP IX,HL

    RET


; TODO See if we can successfully use the SP to speed this up
; Calculate loop counter then use LDI
; copy_buffer_to_screen:
;     PUSH AF,BC,DE,HL

;     LD HL,(_buffer_stack_top)

; .copy_loop
;     ; Any more to do?
;     LD DE, _BUFFER_STACK
;     OR A          ; clear carry flag
;     SBC HL, DE
;     ADD HL, DE    ; and now the flags are set, you can branch

;     ; * IF HL equals DE, Z=1,C=0
;     ; * IF HL is less than DE, Z=0,C=1
;     ; * IF HL is more than DE, Z=0,C=0

;     JR C, .done  ; TODO CHECK - can we reorder the comparison todo one less check (swap HL and DE and check for NC)
;     JR Z, .done

; .more
;     DEC HL                      ; Move to address on the stack
;     DEC HL                      ; We do this first as the pointer is the next free address

;     LD DE,(HL)                  ; Address in buffer that was written to

;     LD A,(DE)                   ; Copy the byte that was written
;     LD B,A                      ; Keep a copy in B

;     LD A,D                      ; Adjust adress to point to actual screen
;     AND 0b00111111              
;     OR  0b01000000
;     LD D,A

;     LD A,B                      ; Copy the buffered byte to the screen
;     LD (DE),A

;     JR .copy_loop

; .done
;     LD HL,_BUFFER_STACK
;     LD (_buffer_stack_top),HL

;     POP HL,DE,BC,AF
    
;     RET


copy_buffer_to_screen:
    DI

    LD (_stack_stash),SP

    PUSH AF,BC,DE,HL

    LD SP,_BUFFER_STACK
    LD HL,(_buffer_stack_top)
    LD A,L
    SUB low _BUFFER_STACK
    LD L,A
    LD A,H
    SBC high _BUFFER_STACK
    LD H,A

.copy_loop
    LD A,H
    OR L
    JP Z,.done

    DEC HL
    DEC HL
    
.more
    POP DE

    LD A,(DE)                   ; Copy the byte that was written
    LD B,A                      ; Keep a copy in B

    LD A,D                      ; Adjust adress to point to actual screen
    AND 0b00111111              
    OR  0b01000000
    LD D,A

    LD A,B                      ; Copy the buffered byte to the screen
    LD (DE),A

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    POP HL,DE,BC,AF
    
    LD SP,(_stack_stash)

    EI

    RET

_stack_stash:       BLOCK 2

_BUFFER_STACK:      BLOCK 512   
_END_OF_STACK:
_buffer_stack_top:  BLOCK 2             ; This points to the next free location on the stack

check_stack_overflow:
    PUSH AF,DE,HL

    LD DE,_END_OF_STACK
    LD HL,(_buffer_stack_top)
    OR A
    SBC HL,DE
    ADD HL,DE
    JR C, .ok

    DB_FLAG_ERROR error_codes.UB_DOUBLE_BUFFER_STACK_OVERFLOW

.ok:
    POP HL,DE,AF

    RET

    MACRO CHECK_STACK_OVERFLOW
        IFDEF DEBUG
            CALL double_buffer.check_stack_overflow
        ENDIF
    ENDM

    ENDMODULE