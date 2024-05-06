; Stack_Top:              EQU 0x0000                              ; Stack at top of RAM
IM2_Table:              EQU 0xFE00                              ; 256 byte page (+ 1 byte) for IM2
IM2_JP:                 EQU 0xFDFD                              ; 3 bytes for JP routine under IM2 table
 
Initialise_Interrupt:   DI
                        LD DE, IM2_Table                        ; The IM2 vector table (on page boundary)
                        LD HL, IM2_JP                           ; Pointer for 3-byte interrupt handler
                        LD A, D                                 ; Interrupt table page high address
                        LD I, A                                 ; Set the interrupt register to that page
                        LD A, L                                 ; Fill page with values
1:                      LD (DE), A 
                        INC E
                        JR NZ, 1B:
                        INC D                                   ; In case data bus bit 0 is not 0, we
                        LD (DE), A                              ; put an extra byte in here
                        LD (HL), 0xC3                           ; Write out the interrupt handler, a JP instruction
                        INC L
                        LD (HL), low Interrupt                  ; Store the address of the interrupt routine in
                        INC L
                        LD (HL), high Interrupt
                        IM 2                                    ; Set the interrupt mode
                        EI                                      ; Enable interrupts
                        RET


Interrupt:              DI
                        EI
                        RET