;------------------------------------------------------------------------------
; Draw the score screen.
;
; Usage:
;   CALL display_score_screen
;------------------------------------------------------------------------------

display_score_screen:
    CALL draw_utils.wipe_screen
    
    CALL setup_interrupt_handler

    CALL game_screen.print_scores_section
    CALL game_screen.draw_credits_section
    CALL game_screen.draw_score_table_section

    RET

;------------------------------------------------------------------------------
; Draw the insert coin screen.
;
; Usage:
;   CALL display_coin_screen
;------------------------------------------------------------------------------

display_coin_screen:
    PUSH HL

    CALL draw_utils.wipe_screen
    
    CALL setup_interrupt_handler

    CALL game_screen.print_scores_section
    CALL game_screen.draw_credits_section
    
    LD L,utils.TRUE_VALUE
    PUSH HL
    CALL game_screen.draw_insert_coin_section
    POP HL

    POP HL
    
    RET

;------------------------------------------------------------------------------
; Draw the push player 1 screen.
;
; Usage:
;   CALL display_push_player_1_screen
;------------------------------------------------------------------------------

display_push_player_1_screen:
    CALL draw_utils.wipe_screen

    CALL player_lives.new_game
    CALL scoring.new_game

    CALL setup_interrupt_handler

    CALL game_screen.print_scores_section
    CALL game_screen.draw_push_player_1_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section

    RET

;------------------------------------------------------------------------------
; Draw the ready player 1 screen.
;
; Usage:
;   CALL display_ready_player_1_screen
;------------------------------------------------------------------------------

display_ready_player_1_screen:
    CALL draw_utils.wipe_screen

    CALL setup_interrupt_handler

    CALL game_screen.print_scores_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section
    CALL game_screen.draw_get_ready

    RET

;------------------------------------------------------------------------------
; Play a demo.
;
; Usage:
;   CALL play_demo
;------------------------------------------------------------------------------
play_demo:
    CALL draw_utils.wipe_screen

    CALL player_lives.new_game
    CALL scoring.new_game
    CALL orchestration.new_game
    CALL aliens.new_game
    CALL alien_missiles.new_game

    CALL game_screen.print_scores_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section
    CALL demos.run_demo

    RET

;------------------------------------------------------------------------------
; Play the game.
;
; Usage:
;   CALL play_game
;------------------------------------------------------------------------------

play_game:
    PUSH AF

    CALL setup_interrupt_handler
    CALL draw_utils.wipe_screen

    LD A,game.GAME_MODE_PLAY_VALUE
    LD (game.game_mode),A

    CALL player_lives.new_game
    CALL scoring.new_game
    CALL orchestration.new_game
    CALL aliens.new_game
    CALL alien_missiles.new_game

    CALL game_screen.print_scores_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section
    CALL game_screen.draw_get_ready

    CALL game.main_game_loop

    POP AF

    RET