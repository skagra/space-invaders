OFF_SCREEN_BUFFER_START: EQU 0xC000

_BUFFER_STACK: BLOCK 512
_BUFFER_STACK_FENCE: BLOCK 2                            ; WPMEM,2                      
_buffer_stack_top: BLOCK 2                              ; This points to the next free location on the stack
