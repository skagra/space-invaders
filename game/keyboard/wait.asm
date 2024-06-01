wait:
.PARAM_MASK EQU 4

    PUSH AF

    LD  IX,0                                            
    ADD IX,SP

.keep_waiting:
    LD A, (keyboard.keys_down)
    AND (IX+.PARAM_MASK)
    JR Z,.keep_waiting

    POP AF

    RET