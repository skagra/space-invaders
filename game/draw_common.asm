    MODULE draw_common

_module_start:

    INCLUDE "y_mem_row_lookup.asm"

init:
    RET

; Collision detection
collided:          BLOCK 1              ; The last draw operation detected a collision

    MEMORY_USAGE "draw common",_module_start

    ENDMODULE