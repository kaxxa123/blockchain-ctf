# Motorbike

[Motorbike](https://ethernaut.openzeppelin.com/level/0x9b261b23cE149422DE75907C6ac0C30cEc4e652A)

_selfdestruct its engine and make the motorbike unusable_

1. The implementation contract `Engine` is making a `delegatecall` in `_upgradeToAndCall`.
1. The attacker can directly initialize the `Engine` contract and...
1. ...call `upgradeToAndCall` providing the address of a malicious contract and...
1. ...instruct `upgradeToAndCall` to call the malicious contract which...
1. ...executes a `_selfdestruct`.

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

## Vulnerability Testing Tools


<BR />

### Slither

__Bug Detected__: _contract that does not protect its initiliaze functions_

__Bug Detected__: _delegatecall to a input-controlled function id_

```BASH
solc-select use 0.6.12

slither ./src/Engine.sol  --exclude-optimization  \
    --solc-remaps "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/" \
    --exclude-informational
```

```
Engine._upgradeToAndCall(address,bytes) (src/Engine.sol#36-46) uses delegatecall to a input-controlled function id
        - (success) = newImplementation.delegatecall(data) (src/Engine.sol#43)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#controlled-delegatecall

Engine (src/Engine.sol#7-58) is an upgradeable contract that does not protect its initiliaze functions: Engine.initialize() (src/Engine.sol#18-21). Anyone can delete the contract with: 
Engine.upgradeToAndCall(address,bytes) (src/Engine.sol#25-28)Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unprotected-upgradeable-contract
./src/Engine.sol analyzed (3 contracts with 57 detectors), 2 result(s) found
```

<BR />


### Mythril

__Bug Detected__:  _Delegatecall to user-supplied address_

```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/22_Motorbike:/share `
        mythril/myth `
        analyze /share/src/Engine.sol `
        --solc-json /share/mythril_map.json `
        --solv 0.6.12
```

```
==== Integer Arithmetic Bugs ====
SWC ID: 101
Severity: High
Contract: Engine
Function name: upgradeToAndCall(address,bytes)
PC address: 753
Estimated Gas Usage: 9168 - 67116
The arithmetic operator can overflow.
It is possible to cause an integer overflow or underflow in the arithmetic operation.
--------------------
In file: /share/src/Engine.sol:43

newImplementation.delegatecall(data)

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x1, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: initialize(), txdata: 0x8129fc1c, value: 0x0
Caller: [ATTACKER], function: upgradeToAndCall(address,bytes), txdata: 0x4f1ef28600000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000, decoded_data: ('0x0000000000000000000000000000000000000020', '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'), value: 0x0

==== Delegatecall to user-supplied address ====
SWC ID: 112
Severity: High
Contract: Engine
Function name: upgradeToAndCall(address,bytes)
PC address: 815
Estimated Gas Usage: 9168 - 67116
The contract delegates execution to another contract with a user-supplied address.
The smart contract delegates execution to a user-supplied address.This could allow an attacker to execute arbitrary code in the context of this contract account and manipulate the state the context of this contract account and manipulate the state of the contract account or execute actions on its behalf.   
--------------------
In file: /share/src/Engine.sol:43

newImplementation.delegatecall(data)

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x1, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: initialize(), txdata: 0x8129fc1c, value: 0x0
Caller: [ATTACKER], function: upgradeToAndCall(address,bytes), txdata: 0x4f1ef286000000000000000000000000deadbeefdeadbeefdeadbeefdeadbeefdeadbeef0000000000000000000000000000000000000000adbeefdeadbeefdeadbeef00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000fdeadbeefdeadbeefdeadbeef', '\x00\x00\x00\x00\x00\x00\x00\x00\000000000000000000000000000, decoded_data: ('0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef', '\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'), value: 0x0
```