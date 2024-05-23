# Building

The project is built using the `sjasmplus` assembler.  

`Sjasmplus` may be downloaded [here](https://github.com/z00m128/sjasmplus), it is available for Windows, MacOS and Linux.

Once installed the project is built as follows:

```
sjasmplus main.asm
```

The build may be configured via the following settings, specified with the `-D` flag on the `sjasmplus` command line:

* `DEBUG` - Enable various diagnostics.
* `IGNORE_VSYNC` - Don't wait for the vertical sync to begin copying the off-screen buffer to screen memory.
* `AUTO_FLUSH` - Copy the off-screen buffer to screen memory immediately after each draw operation.
* `DIRECT_DRAW` - Draw directly to the screen rather than using the off-screen buffer.    
* `PAUSEABLE` - Press space to pause game.
* `NO_SHIELDS` - Don't draw shields.

For a standard *release* build specify none of the above.

The build will generate the following files:

If `DEBUG` is **not** defined then output will be written to:
* `bin/space-invaders-release.sna` - Snapshot file.
* `bin/space-invaders-release.tap` - Tap file.
* 
If `DEBUG` is defined then output will be written to:
* `bin/space-invaders-debug.sna` - Snapshot file.
* `bin/space-invaders-debug.tap` - Tap file.     


