# Building

The project is built using the `sjasmplus` assembler, optionally via GNU `make`.

`Sjasmplus` may be downloaded [here](https://github.com/z00m128/sjasmplus), it is available for Windows, MacOS and Linux.

GNU `make` is native on Linux and ports are available for Windows.

The project is built as follows:

```
make all
```

Or if you don't have `make` available, a release version may be built directly using the assembler.

```
sjasmplus main.asm
```

# Makefile Targets

The `Makefile` contains the following targets:

* `all` - Build everything.
* `debug` - Build a debug version.
* `tests` - Build tests.
* `sprites` - Rebuild "shifted" sprites from source version.  This target requires that `dotnet` be installed and in your path.
* `release` - Build a release version.
* `clean` - Clean all build files.
* `run-cspect-debug` - Run a debug build in the `CSpect` emulator.
* `run-cspect-release` - Run a release build in the `CSpect` emulator.
* `run-mame-debug` - Run a debug build in `MAME`.
* `run-mame-release` - Run a release build in `MAME`.
* `run-cspect-tests` - Run tests in the `CSpect` emulator.
* 
**Note** that `all`, `debug` and `release` require that `sjasmplus` is in your `PATH`, `run-cspect-*` require that `CSpect.exe` is your `PATH` and `run-mame-*` require that both `mame` is in your `PATH` and that the `spectrum` ROM has been added (see [running](running.md)).  The `clean` target requires that `OS` environment variable is set correctly, `Windows_NT` for Windows and `Linux` for Linux.

# Configuring the Build

The build may be configured via the following settings, specified with the `-D` flag on the `sjasmplus` command line, or by editing `DEBUG_FLAGS` in `game/Makefile`

* `DEBUG` - Enable various diagnostics.
* `IGNORE_VSYNC` - Don't wait for the vertical sync to begin copying the off-screen buffer to screen memory.
* `AUTO_FLUSH` - Copy the off-screen buffer to screen memory immediately after each draw operation.
* `DIRECT_DRAW` - Draw directly to the screen rather than using the off-screen buffer.    
* `PAUSEABLE` - Press space to pause game.
* `NO_SHIELDS` - Don't draw shields.
* `INVINCIBLE` - Player is invulnerable to alien missiles.
 
For a standard *release* build specify none of the above.

# Output Files

The build will generate the following files:

If `DEBUG` is **not** defined then output will be written to:
* `bin/space-invaders-release.sna` - Snapshot file.

If `DEBUG` is defined then output will be written to:
* `bin/space-invaders-debug.sna` - Snapshot file.
 


