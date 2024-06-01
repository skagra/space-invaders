; Modified from:  http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/interrupts
setup:
    PUSH AF,DE,HL

    DI                                      ; Disable interrupts
    LD DE, INTERRUPT_VECTOR_TABLE           ; The IM2 vector table - must be on a page boundary
    LD HL, INTERRUPT_JUMP                   ; Pointer for 3-byte interrupt handler

    LD A, D                                 ; Interrupt table page high address
    LD I, A                                 ; Set the interrupt register to that page

    ; Set up vector table
    LD A, L                                 ; Fill page with values

.fill_loop:  
    LD (DE), A 
    INC E
    JR NZ,.fill_loop
    INC D                                   ; In case data bus bit 0 is not 0, we
    LD (DE), A                              ; put an extra byte in here

    ; Set up jump to handler instruction
    LD (HL), 0xC3                           ; JP op code
    INC L
    LD (HL), low handler                    ; Store the address of the interrupt routine in
    INC L
    LD (HL), high handler

    ; Set the interrupt mode
    IM 2

    ; Enable interrupts                                    
    EI

    POP HL,DE,AF

    RET
  
INTERRUPT_JUMP:         EQU 0xFDFD          ; 3 bytes for JP routine under IM2 table
INTERRUPT_VECTOR_TABLE: EQU 0xFE00          ; 256 byte page (+ 1 byte) for IM2
