;------------------------------------------------------------------------------
;
; Draw the current alien missile/explosion.
; 
; Usage:
;   CALL draw
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

draw:
    PUSH DE,HL,IX

    LD IX,(_current_alien_missile_ptr)                      ; Point IX to current missle struct

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)                   ; Current missile state

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A                   ; Active? Draw the missle.
    JR NZ,.draw_missile

    BIT _ALIEN_MISSILE_STATE_REACHED_BOTTOM_OF_SCREEN_BIT,A ; Reached the bottom of the screen? Draw the missile exploding.
    JR NZ,.draw_explosion

    JR .done

.draw_missile:
    ; Draw the current alien missile
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Coords
    PUSH DE
    
    LD DE,sprites.ALIEN_MISSILE_0_VARIANT_0_DIMS            ; Dimensions
    PUSH DE                                                 ; TODO Ideally Dimensions should really be pulled from the actual variant!

    ; Which variant are we dealing with?                    
    LD D,0x00                                               ; Current alien missile variant
    LD E,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)
    SLA E                                                   ; Double it - as there are WORDs in alien missile struct
    LD HL,_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0            ; Add on the offset for the first variant
    ADD HL,DE                                               ; HL now contains the offset of the address of the variant (offset from IX)
    LD DE,IX                                                ; Offset from the base address
    ADD HL,DE
    LD DE,(HL)
    PUSH DE                                                 ; Sprite/mask of correct variant

    LD E,utils.FALSE_VALUE                                  ; Drawing (not blanking)
    PUSH DE 

    LD DE,collision.alien_missile_collision                 ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                                   ; Draw the missile
   
    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

    JR .done

.draw_explosion:
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Coords
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION_DIMS              ; Dimensions
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION                   ; Spite/mask
    PUSH DE

    LD E,utils.FALSE_VALUE                                  ; Drawing (not blanking)
    PUSH DE

    LD DE,collision.dummy_collision                         ; Where to record collision data
    PUSH DE
    
    CALL draw.draw_sprite                                   ; Draw the explosion
   
    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP IX,HL,DE

    RET

;------------------------------------------------------------------------------
;
; Blank the current alien missile/explosion.
; 
; Usage:
;   CALL blank
;
; Return values:
;   -
;
; Registers modified:
;   -
;
;------------------------------------------------------------------------------

blank:
    PUSH AF,DE,HL,IX

    LD IX,(_current_alien_missile_ptr)                      ; Point IX to current missle struct

    LD A,(IX+_ALIEN_MISSILE_OFFSET_STATE)                   ; Grab current missile state

    BIT _ALIEN_MISSILE_STATE_ACTIVE_BIT,A                   ; Active?
    JR NZ,.blank_missile                                    ; Y - handle it
    
    BIT _ALIEN_MISSILE_STATE_DONE_AT_BOTTOM_OF_SCREEN_BIT,A ; Finished blowing up at the bottom of the screen?
    JR NZ,.blank_explosion                                  ; Y - handle it

    BIT _ALIEN_MISSILE_STATE_HIT_SHIELD_BIT,A               ; Alien missile has hit a shield
    JR NZ,.blank_missile                                    ; Handle it
    
    JR .done                                                ; Nothing to do for other states

.blank_missile:
    ; Draw the current alien missile
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Coords
    PUSH DE
    
    LD DE,sprites.ALIEN_MISSILE_0_VARIANT_0_DIMS            ; Dimensions
    PUSH DE                                                 ; TODO This should really be pulled from the actual variant!

    ; Which variant are we dealing with?                    ; Sprite/mask
    LD D,0x00                                               ; Current alien sprite variant
    LD E,(IX+_ALIEN_MISSILE_OFFSET_CURRENT_VARIANT)
    SLA E                                                   ; Double it - as there are WORDs in this part of the alien struct
    LD HL,_ALIEN_MISSILE_OFFSET_SPRITE_VARIANT_0            ; Add on the offset for the first variant
    ADD HL,DE                                               ; HL now contains the offset of the address of the variant (offset from IX)
    LD DE,IX                                                ; Offset from the base address
    ADD HL,DE
    LD DE,(HL)
    PUSH DE                                                 ; Sprite/mask of correct variant

    LD E,utils.TRUE_VALUE                                   ; Blanking (not drawing)
    PUSH DE 

    LD DE,collision.dummy_collision                         ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                                   ; Draw the bullet
   
    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

    BIT _ALIEN_MISSILE_STATE_HIT_SHIELD_BIT,A               ; Alien missile has hit a shield
    JR Z,.done     

.blank_explosion:
    LD DE,(IX+_ALIEN_MISSILE_OFFSET_COORDS)                 ; Coords
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION_DIMS              ; Dimensions
    PUSH DE

    LD DE,sprites.ALIEN_MISSILE_EXPLOSION                   ; Spite/mask
    PUSH DE

    LD E,utils.TRUE_VALUE                                   ; Blanking (not drawing)
    PUSH DE

    LD DE,collision.dummy_collision                         ; Where to record collision data
    PUSH DE

    CALL draw.draw_sprite                                   ; Blank the explosion
   
    POP DE
    POP DE
    POP DE
    POP DE
    POP DE

.done
    POP IX,HL,DE,AF

    RET
