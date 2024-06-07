interrupt_handler:
    DI

    PUSH AF

    CALL keyboard.get_keys

    LD A, (keyboard.keys_down)
    BIT keyboard.PAUSE_KEY_DOWN_BIT,A
    JR Z,.done

    LD A,utils.TRUE_VALUE
    LD (_next_screen),A

.done
    POP AF
    
    EI
 
    RET