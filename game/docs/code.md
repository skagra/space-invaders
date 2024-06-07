# Code Overview

This document describes the overall structure of the code base.

# Main

* [`main.asm`](../main.asm) - Main entry point.
  
# Module Structure

The code base is structured into a set of *modules*.  Each module is contained in a single directory with a standard entry point `module.asm` which is responsible for loading all other module files.

There are several standard files and entry points which each module may implement:

* `init.asm` - Module initialization which may contain the following entry points:
  * `init` - One-off module initialization.
  * `new_game` - Called to initialize a new game.
  * `new_sheet` - Call when a new sheet of aliens is created.
* `state.asm` - All state and constant information.
* `draw.asm` - Drawing routines.
* `update.asm` - Per-animation cycle state update.
* `events.asm` - Handling of game events.
  
# Conventions

The following naming conventions are used throughout the code base:

* `CONSTANT` - Constants are upper case.
* `state` - State is lower case (snake case for multiple words).
* `_PRIVATE_CONSTANT` - Module-private constants are prefixed with an underscore.
* `_private_state` - Module-private state is prefixed with an underscore.

# Modules

* [`alien_missiles`](../alien_missiles) - Missiles fired by aliens.
* [`aliens`](../aliens) -  The pack of aliens.
* [`character_set`](../character_set) - Bitmaps of the character font.
* [`collision`](../collision) - Collision detection routines.
* [`collision_state`](../collision_state) - Collision state partial module, to allow inclusion of draw routines avoiding coupling through the collision routines.
* [`colours`](../colours) - Colour and border attribute routines.
* [`credits`](../credits) - Handling of player credits.
* [`debug`](../debug) - Debug routines.
* [`double_buffer`](../double_buffer) - Off-screen buffer for flicker free screen updates.
* [`draw`](../draw) - Generic double-buffered sprite drawing.
* [`draw_utils`](../draw_common) - Shared drawing routines.
* [`fast_draw`](../fast_draw) - Optimized fixed size double-buffered sprite drawing.
* [`game`](../game) - Main game play loop.
* [`game_screen`](../game_screen) - Game screens "chrome".
* [`interrupts`](../interrupts) - Interrupt handling setup.
* [`keyboard`](../keyboard) - Keyboard scanning.
* [`layout`](../layout) - All layout configuration - pixel and character coordinates.
* [`memory_map`](../memory_map) - ZX Spectrum memory map.
* [`orchestration`](../orchestration) - Coordination of state/activities across multiple game objects.
* [`player`](../player) - Player base.
* [`player_lives`](../player_lives) - Player lives.
* [`player_missile`](../player_missile) - Missile fired by the player.
* [`print`](../print) - Generic text printing.
* [`scoring`](../scoring) - BCD scoring.
* [`screen`](../screen) - Screen dimensions constants.
* [`splash_screen`](../splash_screen) - Introductory splash screens.
* [`sprites`](../sprites) - Pre-shifted sprites.
* [`utils.asm`](../utils) - Various generic utility routines.
  
  # Other Directories

* [`sprites_source`](../sprites_source) - Sprite images processed to create pre-shifted sprites in the [`sprites`](../sprites) module.
* [`docs`](../docs) - Documentation.
* [scripts](../scripts) - Scripts to run `dotnet` projects to create shifted sprites and to calculate screen memory lookup table.
* [`tests`](../tests) - Code tests.