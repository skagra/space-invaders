# Space Invaders

A faithful reproduction of the original arcade Space Invaders game, as released in 1978 by Taito. Implemented in Z80 machine code for the ZX Spectrum 48K. 

![Current Status](docs/animation.gif)

# Contents

* [game](game) - The game code.
* [screen-lookup-table](screen-lookup-table) - A utility to generate a lookup table to resolve coordinates to the corresponding screen memory address.
* [shift-sprites](shift-sprites) - A utility to generate "pre-shifted" versions of sprite data for efficient rendering.

# Tooling

* [Visual Studio Code](https://code.visualstudio.com/) - IDE.
* [DeZog](https://github.com/maziac/DeZog) - Z80/Spectrum development environment for VSCode. 
* [Sjasmplus](https://github.com/z00m128/sjasmplus) - Z80 Assembler.
* [CSpect](https://mdf200.itch.io/cspect) - ZX Spectrum Emulator. 

# Status

In terms of major game play elements the following remain to be implemented:

* Full collision detection.
* Alien destruction by player missiles.
* Alien missiles.
* Scoring.
* Saucer ship.

The project is now hitting a hurdle in squeezing out enough performance from the ZX Spectrum to remain flicker free while completing the feature set - some optimization will be required and possibly a change in approach to rendering entirely.
