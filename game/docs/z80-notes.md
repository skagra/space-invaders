# 16 Bit Compare

```
    OR A          ; clear carry flag
    SBC HL, DE
    ADD HL, DE    ; and now the flags are set, you can branch
```

* IF HL equals DE, Z=1,C=0
* IF HL is less than DE, Z=0,C=1
* IF HL is more than DE, Z=0,C=0

# 16 Bit Loop

```
    LD DE,NNNN
.loop:
    ; ... 
    DEC DE
    LD A,D
    OR E
    JP NZ,.loop
```

# Double a 16 Bit Value

```
    SLA L                                              
    RL H
```

If only one shift is needed, then this is faster:

```
    ADD HL,HL
```

Likewise for 8 bit registers:

```
    ADD A,A
```

# Compare A to Zero with Modifying

```
    AND A
```

# Copy SP into an Index Register

```
    LD  IX,0
    ADD IX,SP   
```

# Compare

```
    CP 10
```

* `Z` => `A=10` 
* `NZ` => `A!=10` 
* `C` =>`A<10`  
* `NC` =>`A>=10`  

# Set A=0

```
    XOR A
```

# Compare A==0

```
    AND A
```
