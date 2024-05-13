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