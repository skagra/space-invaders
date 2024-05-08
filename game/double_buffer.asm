    MODULE double_buffer

init:
    PUSH HL

    LD HL,_BUFFER_STACK
    LD (_buffer_stack_top),HL

    LD HL,_FAST_BUFFER_STACK
    LD (_fast_buffer_stack_top),HL

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

._PARAM_COORDS:            EQU 10                       ; Sprite coordinates
._PARAM_DIMS:              EQU 8                        ; Sprite dimensions
._PARAM_SPRITE_DATA:       EQU 6                        ; Sprite pre-shifted data lookup table
    
    PUSH HL,IX

    LD  IX,0                                            ; Point IX to the stack
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

    ; For 16 bit wide sprite => 24 bits of pre-shifted image
    MACRO COPY_LINE_16
        POP HL                                          ; Get the address written to in the off screen buffer
        LD D,H                                          ; Copy address in DE - this will become the screen address                  
        LD E,L
        RES 7,D                                         ; Reset bit 7 to make screen address
        LDI                                             ; LD (DE),(HL) INC HL INC DE DEC BC - 
        LDI                                             ; LD (screen_ptr), (buffer_ptr), INC screen_ptr, INC buffer_pointer, DEC loop_counter
        LDI 
    ENDM

fast_copy_buffer_to_screen_16x8:
    DI                                                  ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (_fast_stack_stash),SP                                ; Store current SP to restore at end

    LD SP,_FAST_BUFFER_STACK                                 ; Subtract the start of stack area (low mem)
    LD HL,(_fast_buffer_stack_top)                           ; from current stack pointer (first free byte)
    LD A,L
    SUB low _FAST_BUFFER_STACK
    LD C,A
    LD A,H
    SBC high _FAST_BUFFER_STACK
    LD B,A
    
    SRL B                                               ; Divide the result by two to give number of loops to                                 
    RR C                                                ; run as we are dealing with word chunks on the stack 

    LD H,B                                              ; Tripple BC - As only the first address of each row was added to the stack
    LD L,C
    ADD HL,BC
    ADD HL,BC
    LD B,H
    LD C,L

.copy_loop
    LD A,B                                              ; Is the copy counter zero?
    OR C
    JP Z,.done                                          ; Yes - done

.more                                     
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16
    COPY_LINE_16

    JR .copy_loop

.done
    LD HL,_FAST_BUFFER_STACK                                 ; Reset the stack
    LD (_fast_buffer_stack_top),HL
    
    LD SP,(_fast_stack_stash)                                ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

_FAST_BUFFER_STACK:      BLOCK 512   
_FAST_END_OF_STACK:
_fast_buffer_stack_top:  BLOCK 2             ; This points to the next free location on the stack
_fast_stack_stash:       BLOCK 2

copy_buffer_to_screen:
    DI                                      ; Disable interrupts as we'll be messing with SP

    PUSH AF,BC,DE,HL

    LD (_stack_stash),SP                    ; Store current SP to restore at end

    LD SP,_BUFFER_STACK                     ; Subtract start of stack area (low mem)
    LD HL,(_buffer_stack_top)               ; from current stack pointer (first free byte)
    LD A,L
    SUB low _BUFFER_STACK
    LD L,A
    LD A,H
    SBC high _BUFFER_STACK
    LD H,A
     
    SRL H                                   ; Divide the result by two to give number of loops to run
    RR L                                    ; as we are dealing with word chunks on the stack

.copy_loop
    LD A,H                                  ; Is the copy counter zero?
    OR L
    JP Z,.done                              ; Yes - done

    DEC HL                                  ; No - decrase the counter

.more
    POP DE                                  ; Get the address written to in the off screen buffer

    LD A,(DE)                               ; Copy the byte that was written
    RES 7,D
    LD (DE),A

    JR .copy_loop

.done
    LD HL,_BUFFER_STACK                     ; Reset the stack
    LD (_buffer_stack_top),HL
    
    LD SP,(_stack_stash)                    ; Restore the original SP

    POP HL,DE,BC,AF

    EI

    RET

_BUFFER_STACK:      BLOCK 512   
_END_OF_STACK:
_buffer_stack_top:  BLOCK 2             ; This points to the next free location on the stack
_stack_stash:       BLOCK 2

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