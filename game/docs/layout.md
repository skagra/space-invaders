# Game Screen Layout

* Screen height = 192 pixels
  
```
000 ->
        SCORE<1>    (8 pixels)
        0000        (8 pixels)
016 ->
        GAP         (16 pixels)
032 ->  
        TOP OF HIGHEST ALIEN               <--|
        X X X       (8 pixels)                |
        GAP         (8 pixels)                |
        X X X                                 |   
        GAP                                   |
        X X X                            (72 pixels)
        GAP                                   |
        X X X                                 |
        GAP                                   |
        X X X                                 |
096 ->  TOP OF LOWEST ALIEN                   |
104 ->  FIRST PIXEL ROW BELOW PACK         <--|
        GAP         (40 pixels)                   
144 ->
        SHIELD      (16 pixels)
160 -> 
        GAP         (8 pixels)
168  ->
        PLAYER      (8 pixels)
176 ->
        GAP         (8 pixels)
184 ->
        CREDIT 00   (8 pixels)
191 ->
```

## Pack Starting Offsets

The alien pack starts progressively lower as the game proceeds.

The 48 pixel gap between the top of the lowest alien and the top of the shields allows for `(48 pixels - 8 height of alien)/8 pixels gap size = 5` 8 pixel offsets (plus the 0 offset) from initial pack starting position to pack starting right above shields.  

This gives potential offsets of:

```
0x00 0x08 0x10 0x18 0x20 0x28
```

## Pack Landing Y

The player loses a life if any alien "lands".  Landing is when an alien reaches a Y coordinate >= player Y coordinate, so `Y>=168`.

