    MODULE error_codes

_module_start:

init:
    RET

UDC_SHOULD_NOT_BE_REACHED:  EQU "A"     ; Ureachable code in alien_pack.update_current_alien reached!
UB_SHOULD_NOT_BE_REACHED:   EQU "B"     ; Ureachable code in player_bullet.update_bullet reached!

    MEMORY_USAGE "error codes     ",_module_start

    ENDMODULE