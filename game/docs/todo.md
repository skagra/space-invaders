# Ideas & To Dos

* Rearrange sprite into two variant packs then we can do the variant check once per pack draw cycle
* Keep track of bottom left and then we can do collision detection based on pixel hit + relative position.
* Where we have case statements like _adjust_alien_pack_direction, could we get a speed increase via an index into a jump table?
* Revise naming of masks and blanks
* ~~Consider proper masks for aliens rather than just a block~~
* Bullet drawing needs to be faster!
* We might need to separate blanking and drawing - with blanking taking place once the raster has dropped of the bottom of the screen but before the retrace
* Single line player bullet does not need 16 bit shifted sprites
* Can we use LDI to speed up the copying of the sprite data
* Do we need to used an off screen buffering technique to get the speed - we draw off screen, take note of the addresses and then just copy the relevant address on screen on update?  We could also log the addresses for blanking too.  SP trick might be relevant here - PUT the SP at the start of the data and just POP off addresses?   Actually we could actually have a stack where we push on the data too ummm width though
* Look for TState counter
* Investigate use of sound chip on Spectrum 128K
* All the sprite names should be upper case to fit with convention
* When base in moving the origin of player bullets seems to lag its position - it seems that it all about getting the starting Y coord correct
* There should be 55 invaders not 50!
* ~~Add a mechanism to allow player bullet explosions to remain on the screen for a configurable period~~
* Remove all pseudo instruction
* Review register usage throughout
* ~~The wait on screen routine - only works properly if the barrier bar is at least once line before the end of the screen else we are on go slow - I suspect this is because the existing wipe code is too slow to complete before the vertical retrace so we end up with 50 speed.~~ ABANDONED
* Look at combining the mask and sprite draw phases (and possible change the storage to Sprite Byte,Mask Byte ... then we can grab both at same time via SP) and collision can go together - also have the mask already "inverted" will save time too
* Figure out if any interrupt handling is being called, install my own and see if this makes using the stack manipulation a stable option.
* Sort out memory map - look to see if assembler can help with layout - initial round done, but more to do as code develops.
* Add DISPLAY WARNING and DISPLAY ERROR macros if possibly
* Add some sort of SAFE INCLUDE mechanism
* Add DIRECT DRAW (no buffering directive)
* ~~Add messages showing memory usage of data and code areas~~
* ~~Half the number of generated alien sprite data using the fact they are only ever at even coord~~
* Add error trap for odd alien x coord
* ~~Move fast draw and double buffering into own file~~
* ~~Move regular double buffering into regular draw file~~
* Add slow draw directive that always uses slow draw routines
* ~~Use lookup table scanning in regular drawing rather that recalculation of coords for each line~~
* .local for local values rather than ._local
* ~~Integrate fast draw into game~~
* Consider fast draw for one byte wide sprites (this is potentially 4 sprites per refresh)
* Uppercase sprite names
* Add fast run options that compiles out wait for vsync
  