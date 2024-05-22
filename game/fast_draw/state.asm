; The draw buffer stack holds the addresses in the screen buffer that have been written to
; since it was last flushed.
_draw_buffer_stack_top: BLOCK 2                         ; Points to the next free location on the draw stack
_DRAW_BUFFER_STACK:     BLOCK 512                       ; Size of the draw stack
_BUFFER_STACK_FENCE:    BLOCK 2                         ; WPMEM,2   