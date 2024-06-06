test_text:
    PUSH HL

    LD HL,.TEST_TEXT
    PUSH HL
    LD HL,0x1010
    PUSH HL
    CALL print.print_string
    POP HL
    POP HL

    CALL double_buffer.flush_buffer_to_screen

    POP HL

    RET
.TEST_TEXT: BYTE "TESTING 1 2 3",0 