    MODULE error_codes

init:
    RET

UDC_SHOULD_NOT_BE_REACHED:  EQU "A"     ; Ureachable code in alien_pack.update_current_alien reached!
UB_SHOULD_NOT_BE_REACHED:   EQU "B"     ; Ureachable code in player_bullet.update_bullet reached!
UB_DOUBLE_BUFFER_STACK_OVERFLOW: EQU "C"

    ENDMODULE