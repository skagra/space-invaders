;------------------------------------------------------------------------------
; Sets IX to point to the first param on the stack
;
; Usage:
;   PARAMS_IX num_pushed  ; Num pushed is the number of local values saved on the stack               
;------------------------------------------------------------------------------    
    
    MACRO PARAMS_IX num_pushed
        LD IX,num_pushed*2+2
        ADD IX,SP
    ENDM

;------------------------------------------------------------------------------
; Sets IY to point to the first param on the stack
;
; Usage:
;   PARAMS_IY num_pushed  ; Num pushed is the number of local values saved on the stack               
;------------------------------------------------------------------------------  

    MACRO PARAMS_IY num_pushed
        LD IY,num_pushed*2+2
        ADD IY,SP
    ENDM

