init:
    PUSH AF

    LD A,0x00
    LD (credits),A

    POP AF

    RET