# Running

This project has been tested with both the *CSpect ZX Spectrum Emulator* and the *MAME Multiple Arcade Machine Emulator*.

## CSpect

CSpect may be downloaded [here](https://mdf200.itch.io/cspect), it is available for Windows, MacOS and Linux.

Once installed run as follows:

```
CSpect +tv -60 -w2 -fps -sound -analytics space-invaders-release.sna
```

## MAME

MAME may be downloaded [here](https://www.mamedev.org/), it is available for Windows, MacOS and Linux.

MAME first needs a ZX Spectrum ROM, this may be downloaded [here](https://wowroms.com/en/roms/mame/download-zx-spectrum/107622.html).  Unpack the downloaded zip file into a directory called `spectrum` under the `Roms` folder of your MAME installation.

Then run as follows:

```
mame.exe spectrum -rompath <roms> -dump space-invaders-release.sna -ui_active -effect scanlines -window -ka -waitvsync -aspect 7:3
```

* `<roms>` - Must be set to the directory under which MAME can find `spectrum/spectrum.rom`.  This parameter may be omitted if running from MAME's installation directory.

## JSSpeccy 3

JSSpeccy is an online ZX Spectrum emulator found [here](https://www.jsspeccy.zxdemo.org/).

Click on the *folder* icon (bottom left), select your `space-invaders-release.sna` and you are good to go.

# Running without Splash Screens

In all of the above `space-invaders-release.sna` may be replaced with `space-invaders-release-no-splash.sna` to run a version devoid of splash screens.