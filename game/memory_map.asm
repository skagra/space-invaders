    MODULE mmap

;------------------------------------------------------------------------------
;
; Initialise the module
;
; Usage:
;   CALL init
;
; Return values:
;   -
;
; Registers modified:
;   -
;------------------------------------------------------------------------------
init:
    RET
    
SCREEN_START:       EQU 0x4000
SCREEN_SIZE:        EQU 0x1800

SCREEN_ATTR_START:  EQU 0x5800
SCREEN_ATTR_SIZE:   EQU 0x300

FREE_MEMORY_START:  EQU 0x5CCB
FREE_MEMORY_SIZE:   EQU 0xA28D

ROM_CHARACTER_SET:  EQU 0x3D00

    ENDMODULE