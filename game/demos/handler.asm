demo_interrupt_handler:
    DI

    PUSH AF,DE,HL,IX

    ; Allow credits to be added - credits terminate the demo
    CALL keyboard.get_keys

    LD A, (keyboard.keys_down)
    BIT keyboard.CREDS_KEY_DOWN_BIT,A
    JR Z,.not_a_credit

    CALL credits.event_credit_added

    LD A,utils.TRUE_VALUE                                       ; Credit added - so done
    LD (demo_done),A
    JR .done                                                    

.not_a_credit:
    ; Exit if script is marked as done
    LD A,(demo_done)                                            
    BIT utils.TRUE_BIT,A
    JR NZ,.done

    ; Current demo step
    LD IX,(_demo_script_ptr)

    ; Use the script's current command to simulate key presses
    LD HL,keyboard.keys_down                                    
    LD DE,(IX+DEMO_OFFSET_INSTRUCTION)
    LD (HL),DE

    ; Next iteration of current demo command
    LD A,(_command_iteration)                                   ; Next iteration in current demo command
    INC A
    LD (_command_iteration),A

    ; Are we done with the required number of iterations of the demo step?
    CP (IX+DEMO_OFFSET_COUNT)                                   ; Are we done with this step?
    JR NZ,.done                                                 ; No so all done.                                     

    ; At end of current demo step so move to next demo step
    LD HL,(_demo_script_ptr)
    INC HL
    INC HL
    LD (_demo_script_ptr),HL

    LD A,0x00                                                   ; We've not done any iterations of the new demo command
    LD (_command_iteration),A

    LD A,(_demo_script_step_counter)                            ; We've completed a step of the script
    INC A
    LD (_demo_script_step_counter),A

    ; Have we reached the end of script?
    LD A,(_demo_script_number_of_steps)
    LD E,A
    LD A,(_demo_script_step_counter)
    CP E
    JR NZ,.done

    ; Mark the script as done
    LD A,utils.TRUE_VALUE           
    LD (demo_done),A
  
    LD A,0x00
    LD (keyboard.keys_down),A

.done:
    POP IX,HL,DE,AF
    
    EI

    RET

