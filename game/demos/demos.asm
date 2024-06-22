;------------------------------------------------------------------------------
; Run a demo screen
; 
; Usage:
;   PUSH rr                 ; 0 or 1 to select demo script in LSB
;   CALL run_demo
;   POP rr
;------------------------------------------------------------------------------

run_demo:

.PARAM_DEMO_NUM EQU 0

    PUSH AF,DE,HL,IX

    PARAMS_IX 4                                         ; Get the stack pointer

    ; Set demo mode for the main animation loop
    LD A,game.GAME_MODE_DEMO_VALUE
    LD (game.game_mode),A

    ; Select the demo script
    LD A,(IX+.PARAM_DEMO_NUM)
    CP 0x01                                             ; Script 1?
    JR Z,.demo_1                                        ; Y - select script 1

    LD DE,DEMO_SCRIPT_0                                 ; Select script 0
    LD HL,_demo_script_ptr
    LD (HL),DE

    LD A,DEMO_SCRIPT_0_NUMBER_OF_STEPS
    LD (_demo_script_number_of_steps),A
    JR .continue

.demo_1
    LD DE,DEMO_SCRIPT_1                                 ; Select script 1
    LD HL,_demo_script_ptr
    LD (HL),DE

    LD A,DEMO_SCRIPT_1_NUMBER_OF_STEPS
    LD (_demo_script_number_of_steps),A

.continue
    LD A,0x00                                           ; We've done no iterations of the first command
    LD (_command_iteration),A

    LD A,0x00                                           ; We've done no steps in the demo script
    LD (_demo_script_step_counter),A

    LD A,utils.FALSE_VALUE                              ; Demo is not complete
    LD (demo_done),A

    ; Draw the screen "chrome"
    CALL player_lives.new_game
    CALL scoring.new_game
    CALL orchestration.new_game
    CALL aliens.new_game
    CALL alien_missiles.new_game
    
    ; Set up the interrupt handler that will follow the script and simulate key presses
    LD HL,demo_interrupt_handler
    PUSH HL
    CALL interrupts.set_interrupt_handler
    POP HL

    CALL game.main_game_loop

    POP IX,HL,DE,AF

    RET




 


