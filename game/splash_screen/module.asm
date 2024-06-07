    MODULE splash_screen
_module_start:
    INCLUDE "splash_screen.asm"
    INCLUDE "interrupt_handler.asm"
    INCLUDE "header.asm"
    INCLUDE "print_message.asm"
    INCLUDE "print_continue.asm"
    INCLUDE "state.asm"
    INCLUDE "controls_screen.asm"

    MEMORY_USAGE "splash screen   ",_module_start

    ENDMODULE