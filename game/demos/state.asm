; Shorthand for key presses
_RK:                                EQU keyboard.RIGHT_KEY_DOWN_MASK
_LK:                                EQU keyboard.LEFT_KEY_DOWN_MASK
_FK:                                EQU keyboard.FIRE_KEY_DOWN_MASK

; Demo scripts - initial 0,x are delays to allow the animation loop to be established before the script starts
DEMO_SCRIPT_0:                      BYTE 0,30,_RK,24,_FK,30,_RK,100,_LK|_FK,1,_LK,30,_LK|_FK,1
DEMO_SCRIPT_0_NUMBER_OF_STEPS:      EQU ($-DEMO_SCRIPT_0)/2

DEMO_SCRIPT_1:                      BYTE 0,30,_RK,10,_FK,1,_FK,1,_RK,100,_LK|_FK,1,_RK,50,_FK,1,_LK,100,_FK,1,_RK,20,_FK,1,_FK,1
DEMO_SCRIPT_1_NUMBER_OF_STEPS:      EQU ($-DEMO_SCRIPT_1)/2

; Struct offsets into demo scripts
DEMO_OFFSET_INSTRUCTION:            EQU 0
DEMO_OFFSET_COUNT:                  EQU 1

; State tracking demo progress
_command_iteration:                 BLOCK 1                     ; Counter of iterations current command
_demo_script_step_counter:          BLOCK 1                     ; Counter of current demo step
_demo_script_ptr:                   BLOCK 2                     ; Pointer to current demo step
_demo_script_number_of_steps:       BLOCK 1                     ; Number of steps in current demo script

demo_done:                          BLOCK 1                     ; Flag whether demo is complete