update:
    update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_saucer_state)

    BIT _SAUCER_STATE_NO_SAUCER_VALUE,A
    JR NZ,.
    
    BIT _SAUCER_STATE_ACTIVE_VALUE,A
    JR NZ,.

    BIT _SAUCER_STATE_EXPLODING_VALUE,A
    JR NZ,.

    BIT _SAUCER_STATE_DONE_EXPLODING_VALUE,A
    JR NZ,.

    ; ASSERT This code should never be reached

    JR .done

.no_saucer:
    JR .done

.active:
    JR .done

.exploding:
    JR .done

.done_exploding:
    JR .done

.done
    POP HL,DE,BC,AF

    RET