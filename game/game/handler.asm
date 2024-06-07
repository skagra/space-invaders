handler:
    DI

    PUSH AF

    CALL keyboard.get_keys

    LD A, (keyboard.keys_down)
    BIT keyboard.CREDS_KEY_DOWN_BIT,A
    JR Z,.done

    ; LOGPOINT [INTERRUPTS] Keys=${A:hex}

    CALL double_buffer.flush_buffer_to_screen

    CALL credits.event_credit_added
    CALL game_screen.print_credits          

    CALL double_buffer.flush_buffer_to_screen

.done
    POP AF
    
    EI
 
    RET

setup_interrupt_handler:
    PUSH HL

    LD HL,game.handler
    PUSH HL
    CALL interrupts.set_interrupt_handler
    POP HL

    POP HL

    RET