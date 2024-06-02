main_game_loop:

    PUSH AF,HL

    CALL scoring.new_game

.new_sheet:
    ;CALL draw_common.wipe_screen
    CALL game_screen.wipe_play_area
    ;CALL game_screen.draw_pre_play
    CALL draw.flush_buffer_to_screen
    CALL game_screen.draw_play

    CALL player_missile.new_game
    CALL global_state.new_game
    CALL player.new_game
    CALL player_lives.new_game
    CALL aliens.new_game
    CALL alien_missiles.new_game

.animation_loop:
    ; Reset all collisions
    CALL collision.reset

    ; Erase player base
    CALL player.blank

    ; Erase the current alien
    CALL aliens.blank

    ; Blank current alien missile in cycle 
    CALL alien_missiles.blank

    ; Erase current player missile
    CALL player_missile.blank

    ; Calcate new coordinates for the player base
    CALL player.update

    ; Calculate new coordinates and variant for current alien  
    CALL aliens.update  

    ; Update current alien missile
    CALL alien_missiles.update

    ; Calculate new coordinates and handle state changes for the player missile               
    CALL player_missile.update

    ; Draw the current alien
    CALL aliens.draw

    ; Draw the player base
    CALL player.draw

    ; Draw current alien missile
    CALL alien_missiles.draw

    ; Draw player missile if there is one
    CALL player_missile.draw

    ; Process collisions  
    CALL collision.handle_collision

    ; Update global state information
    CALL global_state.update

    ; Move on to next alien
    CALL aliens.next_alien

    ; Next alien missile
    CALL alien_missiles.next

    IFNDEF IGNORE_VSYNC
        ; Wait for Vsync
        HALT 
    ENDIF
    
    ; Copy off screen buffers to screen memory
    CALL draw.flush_buffer_to_screen
    CALL fast_draw.flush_buffer_to_screen_16x8

    IFDEF PAUSEABLE
        LD L,keyboard.PAUSE_KEY_DOWN_MASK
        PUSH HL
        CALL keyboard.wait
        POP HL
        LD L,keyboard.PAUSE_KEY_DOWN_MASK
        PUSH HL
        CALL keyboard.wait
        POP HL
    ENDIF

    DEBUG_VTRACE_FLASH

    LD A,(aliens.alien_count)
    CP 0x00
    JR Z,.new_sheet

    LD A,(global_state._game_state)
    BIT global_state._GAME_STATE_GAME_OVER_BIT,A
    JP Z,.animation_loop  

    POP HL,AF 

    RET