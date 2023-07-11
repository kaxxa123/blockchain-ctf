# DoubleEntryPoint

[DoubleEntryPoint](https://ethernaut.openzeppelin.com/level/0x9451961b7Aea1Df57bc20CC68D72f662241b5493)

1. The `CryptoVault` has a balance from two tokens called `DoubleEntryPoint`, and `LegacyToken`
1. The `DoubleEntryPoint` token exposes the `DelegateERC20` interface that effecively allows any other token to wrap it.
1. This wrapping means that tokenX can forward transfers to `DoubleEntryPoint`. Whereas the caller might think he is transferring tokenX, it is infact transfering the `DoubleEntryPoint` token.
1. This is exactly what `LegacyToken` is doing. It is forwarding transfers to `DoubleEntryPoint`.
1. Hence when `CryptoVault` tries transfering its `LegacyToken` it is effectively transferring its `DoubleEntryPoint`.
1. To block this attack we need to detect transfers whose original sender is `CryptoVault`.


<BR />

## Attack Test

```DASH
forge test -vvvv
```


<BR />

## Live Attack

```BASH
./attackDeploy.sh
./attackDo.sh
```

<BR />

## Vulnerability Testing Tools


<BR />

### Slither

```BASH
solc-select install 0.8.19
solc-select use 0.8.19

slither ./src/CryptoVault.sol --print contract-summary  \
       --solc-remaps "openzeppelin-contracts/=lib/openzeppelin-contracts/contracts/"
```

