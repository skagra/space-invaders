handler:
    DI

    PUSH AF

    CALL keyboard.get_keys

    LD A, (keyboard.keys_down)
    BIT keyboard.CREDS_KEY_DOWN_BIT,A
    JR Z,.done

    ; LOGPOINT [INTERRUPTS] Keys=${A:hex}

    CALL credits.event_credit_added
    CALL game_screen.print_credits

    CALL draw.flush_buffer_to_screen

.done
    POP AF
    
    EI
 
    RET
