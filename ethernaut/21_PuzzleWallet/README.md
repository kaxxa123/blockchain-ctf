# Puzzle Wallet

[Puzzle Wallet](https://ethernaut.openzeppelin.com/level/0x4dF32584890A0026e56f7535d0f2C6486753624f)

The  vulnerabilities in these contracts arise from:

1. An overlap in the storage slots between the proxy and the wallet contracts.
    This allows us to overwrite the admin addresses.

2. The opportunity to run multiple calls through multicall->delegatecall 
    This allows us to drain the contract balance.


<BR />

## Test Attack

```BASH
forge test --match-contract TestAttack  --match-test testAttack -vvv
```

<BR />

## Live Attack

```BASH
./attackDo.sh
```

<BR />

