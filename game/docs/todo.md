# Ideas & To Dos

* Rearrange sprite into two variant packs then we can do the variant check once per pack draw cycle
* Keep track of bottom left and then we can do collision detection based on pixel hit + relative position.
* Where we have case statements like _adjust_alien_pack_direction, could we get a speed increase via an index into a jump table?
* Revise naming of masks and blanks
* Consider proper masks for aliens rather than just a block
* Bullet drawing needs to be faster!
* We might need to separate blanking and drawing - with blanking taking place once the raster has dropped of the bottom of the screen but before the retrace
* Single line player bullet does not need 16 bit shifted sprites
* Can we use LDI to speed up the copying of the sprite data
* Do we need to used an off screen buffering technique to get the speed - we draw off screen, take note of the addresses and then just copy the relevant address on screen on update?  We could also log the addresses for blanking too.  SP trick might be relevant here - PUT the SP at the start of the data and just POP off addresses?   Actually we could actually have a stack where we push on the data too ummm width though