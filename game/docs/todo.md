# Ideas & To Dos

* Bullet drawing needs to be faster!
* Single line player missile does not need 16 bit shifted sprites
* Can we use LDI to speed up the copying of the sprite data
* Do we need to used an off screen buffering technique to get the speed - we draw off screen, take note of the addresses and then just copy the relevant address on screen on update?  We could also log the addresses for blanking too.  SP trick might be relevant here - PUT the SP at the start of the data and just POP off addresses?   Actually we could actually have a stack where we push on the data too ummm width though
* Look for TState counter
* Investigate use of sound chip on Spectrum 128K
* There should be 55 invaders not 50!
* Remove all pseudo instruction
* Review register usage throughout
* Figure out if any interrupt handling is being called, install my own and see if this makes using the stack manipulation a stable option.
* Add some sort of SAFE INCLUDE mechanism
* Add error trap for odd alien x coord
* Add slow draw directive that always uses slow draw routines
* Consider fast draw for one byte wide sprites (this is potentially 4 sprites per refresh)
* Add coords to inline print
* Add print_and_flush
* Add pointer to first non-dead alien as optimization
* Remove all hard coded positions - replace with constants and calculation - game screen is the greatest offender here
* Replace infinite loop errors traps with ASSERTION
* Review masks and blanks for aliens so they completely eat the shields

  