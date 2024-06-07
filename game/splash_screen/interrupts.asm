setup_interrupt_handler:
    PUSH HL

    LD HL,splash_screen.interrupt_handler
    PUSH HL
    CALL interrupts.set_interrupt_handler
    POP HL

    POP HL

    RET