# Space Invaders

A faithful reproduction of the original arcade Space Invaders game, as released in 1978 by Taito. Implemented in Z80 machine code for the ZX Spectrum 48K. 

<p align="center">
<img src="docs/animation.gif">
</p>

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

Most of the major game elements are now in place, though there is significant work remaining, for example.

* Player base destruction.
* Saucer ship.
* "Landing" page
* Credits and 2 player mode.
* Sound.

