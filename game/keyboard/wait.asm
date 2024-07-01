;------------------------------------------------------------------------------
; Wait for a key to pressed
; 
; Usage:
;   PUSH rr               ; Key to wait for from *_KEY_DOWN_MASK values in LSB
;   CALL wait
;   POP rr
;------------------------------------------------------------------------------

wait:

.PARAM_MASK EQU 0

    PUSH AF

    PARAMS_IX 1                                         ; Point IX to the first stack parameter

.keep_waiting: 
    LD A, (keyboard.keys_down)                          ; Get the keys that have been pressed
    AND (IX+.PARAM_MASK)                                ; Was the key we are waiting for pressed?
    JR Z,.keep_waiting                                  ; No - keep waiting

    POP AF

    RET