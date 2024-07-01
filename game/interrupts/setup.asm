;------------------------------------------------------------------------------
; Set up the interrupt handling vectors
; This code is modified from: http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/interrupts
;
; Interrupt vectors are written into: 0xFE00 -> 0xFF01
; A JP instruction to the handler is held in: 0xFDFD -> 0xFDFF
;
; Interrupt handling is initialised to a null handler routine.
;
; Usage:
;   CALL setup
;------------------------------------------------------------------------------

setup:
    PUSH AF,DE,HL

    DI                                                  ; Disable interrupts

    ; Initial null interrupt handler
    LD HL,null_interrupt_handler
    PUSH HL
    CALL set_interrupt_handler
    POP HL

    LD DE, INTERRUPT_VECTOR_TABLE                       ; The IM2 vector table - must be on a page boundary
    LD HL, INTERRUPT_JUMP                               ; Pointer for 3-byte interrupt handler

    LD A, D                                             ; Interrupt table page high address
    LD I, A                                             ; Set the interrupt register to that page

    ; Set up vector table
    LD A, L                                             ; Fill page with values

.fill_loop:  
    LD (DE), A 
    INC E
    JR NZ,.fill_loop
    INC D                                               ; In case data bus bit 0 is not 0, we
    LD (DE), A                                          ; put an extra byte in here

    ; Set the interrupt mode
    IM 2

    ; Enable interrupts                                    
    EI

    POP HL,DE,AF

    RET
  
;------------------------------------------------------------------------------
; Set up the interrupt handler
;
; Usage:
;    PUSH rr        ; Handler address
;    CALL set_interrupt_handler
;    POP rr
;------------------------------------------------------------------------------
set_interrupt_handler:

.PARAM_HANDLER_ADDRESS: EQU 8

    DI

    PUSH DE,HL,IX

    LD  IX,0                                            ; Point IX to the stack
    ADD IX,SP  

    LD E,(IX+.PARAM_HANDLER_ADDRESS)
    LD D,(IX+.PARAM_HANDLER_ADDRESS+1)

    LD HL,INTERRUPT_JUMP

    ; Set up jump to handler instruction
    LD (HL), 0xC3                                       ; JP op code
    INC HL                                              ; Move to target address
    LD (HL),E                                           ; LSB
    INC HL                                              ; Move to MSB
    LD (HL),D                                           ; MSB

    POP IX,HL,DE

    EI

    RET

;------------------------------------------------------------------------------
; Null interrupt handler - used as a default
;------------------------------------------------------------------------------

null_interrupt_handler:
    RET
