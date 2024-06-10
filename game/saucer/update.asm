update:
    PUSH AF,BC,DE,HL

    ; Grab the current missile state
    LD A,(_saucer_state)

    BIT _SAUCER_STATE_NO_SAUCER_BIT,A
    JR NZ,.no_saucer
    
    BIT _SAUCER_STATE_ACTIVE_BIT,A
    JR NZ,.active

    BIT _SAUCER_STATE_EXPLODING_BIT,A
    JR NZ,.exploding

    BIT _SAUCER_STATE_DONE_EXPLODING_BIT,A
    JR NZ,.done_exploding

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