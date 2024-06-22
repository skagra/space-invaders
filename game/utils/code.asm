    MACRO PARAMS_IX num_params
        LD IX,num_params*2+2
        ADD IX,SP
    ENDM

    MACRO PARAMS_IY num_params
        LD IY,num_params*2+2
        ADD IY,SP
    ENDM

