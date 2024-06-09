    ; ZX Spectrum 48K
    DEVICE ZXSPECTRUM48

    ; Source debugging settings
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION

    ; Skip past contended memory
    ORG 0x8000 

    INCLUDE "build_settings_display.asm"

    INCLUDE "memory_map/module.asm"
    INCLUDE "debug/module.asm"
    INCLUDE "sprites/module.asm"
    INCLUDE "character_set/module.asm"
    INCLUDE "screen/module.asm"
    INCLUDE "utils/module.asm"
    INCLUDE "double_buffer/module.asm"
    INCLUDE "colours/module.asm"
    INCLUDE "draw_utils/module.asm"
    INCLUDE "draw/module.asm"
    INCLUDE "fast_draw/module.asm"
    INCLUDE "keyboard/module.asm"
    INCLUDE "print/module.asm"
    INCLUDE "layout/module.asm"
    INCLUDE "orchestration/module.asm"
    INCLUDE "player/module.asm"
    INCLUDE "player_missile/module.asm"

    ; Off-screen buffer
    ORG double_buffer.OFF_SCREEN_BUFFER_START
DRAW_BUFFER:    BLOCK memory_map.SCREEN_SIZE,0x00

    MEMORY_USAGE "off-screen buffer ", DRAW_BUFFER

    INCLUDE "aliens/module.asm"
    INCLUDE "game_screen/module.asm"
    INCLUDE "splash_screen/module.asm"
    INCLUDE "collision/module.asm"
    INCLUDE "scoring/module.asm"
    INCLUDE "alien_missiles/module.asm"
    INCLUDE "player_lives/module.asm"
    INCLUDE "credits/module.asm"
    INCLUDE "interrupts/module.asm"
    INCLUDE "game/module.asm"

    MODULE main
main: 
    ; Set up stack
    DI                          
    LD SP,STACK_TOP
    EI

    ; Initialise all modules
    CALL debug.init
    CALL orchestration.init
    CALL utils.init
    CALL layout.init
    CALL screen.init
    CALL colours.init
    CALL double_buffer.init
    CALL draw_utils.init
    CALL draw.init
    CALL fast_draw.init
    CALL print.init
    CALL keyboard.init
    CALL game_screen.init
    CALL player.init
    CALL player_missile.init
    CALL aliens.init
    CALL collision.init
    CALL scoring.init
    CALL alien_missiles.init
    CALL player_lives.init
    CALL credits.init
    CALL interrupts.init

    ; Set up interrupt handling vector
    CALL interrupts.setup

    ; Splash and control screens
    CALL splash_screen.setup_interrupt_handler
    CALL splash_screen.draw_splash_screen
    CALL splash_screen.draw_controls_screen

    ; One game screen initialization
    CALL draw_utils.wipe_screen
    CALL game_screen.set_border
    CALL game_screen.set_colours

    ; Credits and keyboard interrupt handling
    CALL game.setup_interrupt_handler

    ; Use the Space Invaders font
    LD HL,print.CHARACTER_SET_SPACE_INVADERS
    PUSH HL
    CALL print.set_font
    POP HL

.score_table:
    ; Draw the score table
    CALL draw_utils.wipe_screen
    CALL game_screen.print_scores_section
    CALL game_screen.draw_credits_section
    CALL game_screen.draw_score_table_section
   
.wait_for_credit:
    LD A,(credits.credits)
    CP 0x00
    JR Z,.wait_for_credit

.push_player_one:
    ; Initialize game state
    CALL player_lives.new_game
    CALL scoring.new_game
    CALL orchestration.new_game
    CALL aliens.new_game

    ; Push player one button
    CALL draw_utils.wipe_screen
    CALL game_screen.print_scores_section
    CALL game_screen.draw_push_player_1_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section

    ; Wait for player one button
    LD L,keyboard.P1_KEY_DOWN_MASK
    PUSH HL
    CALL keyboard.wait
    POP HL

    ; Update credits
    CALL credits.event_credit_used

    ; Ready player 1
    CALL draw_utils.wipe_screen
    CALL game_screen.print_scores_section
    CALL game_screen.draw_player_lives_section
    CALL game_screen.draw_credits_section
    CALL game_screen.draw_get_ready

    ; Main game loop
    CALL game.main_game_loop

    ; Short delay before continuing
    LD HL,0x80                                          ; TODO Pull out into a configurable constant
    PUSH HL
    CALL utils.delay
    POP HL

    ; Any credits?
    LD A,(credits.credits)
    CP 0x00
    JR Z,.score_table

    JR .push_player_one

    MEMORY_USAGE "main            ", main

; Put the stack immediately after the code
STACK_SIZE: EQU 100*2    
STACK_START: BLOCK STACK_SIZE, 0
STACK_TOP: EQU $-1

    MEMORY_USAGE "stack           ", STACK_START
    
    ENDMODULE
                                        
    ORG interrupts.INTERRUPT_JUMP
    BLOCK 3
    MEMORY_USAGE "interrupt jump   ",interrupts.INTERRUPT_JUMP

    ORG interrupts.INTERRUPT_VECTOR_TABLE
    BLOCK 257
    MEMORY_USAGE "interrupt vector ",interrupts.INTERRUPT_VECTOR_TABLE

    TOTAL_MEMORY_USAGE

    ; Save snapshot for spectrum emulator
    IFDEF DEBUG
        SAVESNA "bin/space-invaders-debug.sna",main.main
    ELSE
        SAVESNA "bin/space-invaders-release.sna",main.main
    ENDIF
   
    
