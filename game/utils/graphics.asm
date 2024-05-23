is_point_in_box:
.PARAM_RETURN:              EQU 8

.PARAM_BOX_BOTTOM_RIGHT:    EQU 10
.PARAM_BOX_BOTTOM:          EQU 10
.PARAM_BOX_RIGHT:           EQU 11

.PARAM_BOX_TOP_LEFT_COORDS: EQU 12
.PARAM_BOX_TOP:             EQU 12
.PARAM_BOX_LEFT:            EQU 13

.PARAM_TARGET_COORDS:       EQU 14
.PARAM_TARGET_Y:            EQU 14
.PARAM_TARGET_X:            EQU 15

    PUSH AF,BC,IX

    ; LOGPOINT [IS_POINT_IN_BOX] ---> is_point_in_box

    LD  IX,0                                                ; Point IX to the stack
    ADD IX,SP    

    LD A,FALSE_VALUE                                        ; False returned by default
    LD (IX+.PARAM_RETURN),A

    LD B,(IX+.PARAM_TARGET_X)                               ; Target X
    ; LOGPOINT [IS_POINT_IN_BOX] Target X=${B}

    LD A,(IX+.PARAM_BOX_LEFT)                               ; Box left X
    ; LOGPOINT [IS_POINT_IN_BOX] Box left=${A}
    CP B                                                    ; Compare X coords
    JR NC,.done                                             ; Target X (B) < box left X (A) => outside

    LD A,(IX+.PARAM_BOX_RIGHT)                              ; Box bottom right
    ; LOGPOINT [IS_POINT_IN_BOX] Box right=${A}
    CP B                                                    ; Compare X coords
    JR C,.done                                              ; Target X (B) > box right (A) => outside

    LD B,(IX+.PARAM_TARGET_Y)                               ; Target Y
    ; LOGPOINT [IS_POINT_IN_BOX] Target Y=${B}

    LD A,(IX+.PARAM_BOX_TOP)                                ; Box top                                                      
    ; LOGPOINT [IS_POINT_IN_BOX] Box top=${A}
    CP B                                                    ; Compare Y coords
    JR NC,.done                                             ; Target X (B) < box top (A) => outside

    LD A,(IX+.PARAM_BOX_BOTTOM)                             ; Box bottom
    ; LOGPOINT [IS_POINT_IN_BOX] Box bottom=${A}
    CP B                                                    ; Compare Y coords
    JR C,.done                                              ; Target Y (B) > box bottom (A) => outside                            

    LD A,utils.TRUE_VALUE                                   ; Return success
    LD (IX+.PARAM_RETURN),A   
    ; LOGPOINT [IS_POINT_IN_BOX] Point is within box

.done
    POP IX,BC,AF  
    ; LOGPOINT [IS_POINT_IN_BOX] <--- is_point_in_box

    RET