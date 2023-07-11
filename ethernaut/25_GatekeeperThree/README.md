# Gatekeeper Three

[Gatekeeper Three](https://ethernaut.openzeppelin.com/level/0x03aFA729959cDB6EA3fAD8572b718E88df0594af)

_Cope with gates and become an entrant._

1. `GatekeeperThree` has a typo in the constructor name allowing us to call it and gain contract ownership.
1. `gateOne()` opens by carrying out the attack from a contract rather than an EOA.
1. `gateTwo()` requires us to read the password set stored at the `SimpleTrick` contract. This involves:
    * Initializing it using `GatekeeperThree::createTrick()`
    * Read the storage direclty of `SimpleTrick`.
    * Open the gate with a call to `GatekeeperThree::getAllowance()`
1. `gateThree()` requires transfering more than `0.001 ether` to `GatekeeperThree` and make sure not to define 
the `receive()` or `fallback()` at the Attack contract.

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
