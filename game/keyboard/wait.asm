wait:
.PARAM_MASK EQU 0

    PUSH AF

    PARAMS_IX 1                                         ; Get the stack pointer

.keep_waiting:
    LD A, (keyboard.keys_down)
    AND (IX+.PARAM_MASK)
    JR Z,.keep_waiting

    POP AF

    RET