# Dex Two

[Dex Two](https://ethernaut.openzeppelin.com/level/0x0b6F6CE4BCfB70525A31454292017F640C10c768)

1. `Dex` swaps between any provided tokens.
1. Attacker simply swaps a fake token against a valuable token.
1. The attacker uses the swap price formula to determine exactly how many tokens it should supply the Dex, and the swap amount to drain the balance in one swap.

<BR />

## Attack Test

```DASH
forge test -vv
```

<BR />

## Live Attack

```BASH
./attackDeploy.sh
./attackDo.sh
```

<BR />

