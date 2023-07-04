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

## Vulnerability Testing Tools


<BR />

### Slither

This code is so broken that running such a tool is pointless...


```BASH
solc-select use 0.8.1
slither ./src/.  --exclude-optimization
```

```
PuzzleProxy.constructor(address,address,bytes)._implementation (src/PuzzleProxy.sol#11) shadows:
        - UpgradeableProxy._implementation() (src/UpgradeableProxy.sol#51-57) (function)
        - Proxy._implementation() (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#51) (function)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#local-variable-shadowing

UpgradeableProxy.constructor(address,bytes)._logic (src/UpgradeableProxy.sol#26) lacks a zero-check on :
                - (success) = _logic.delegatecall(_data) (src/UpgradeableProxy.sol#31)
PuzzleProxy.constructor(address,address,bytes)._admin (src/PuzzleProxy.sol#11) lacks a zero-check on :
                - admin = _admin (src/PuzzleProxy.sol#12)
PuzzleProxy.proposeNewAdmin(address)._newAdmin (src/PuzzleProxy.sol#20) lacks a zero-check on :
                - pendingAdmin = _newAdmin (src/PuzzleProxy.sol#21)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

UpgradeableProxy._implementation() (src/UpgradeableProxy.sol#51-57) uses assembly
        - INLINE ASM (src/UpgradeableProxy.sol#54-56)
UpgradeableProxy._setImplementation(address) (src/UpgradeableProxy.sol#72-81) uses assembly
        - INLINE ASM (src/UpgradeableProxy.sol#78-80)
Proxy._delegate(address) (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#22-45) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#23-44)
Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Address.sol#236-239)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Different versions of Solidity are used:
        - Version used: ['^0.8.0', '^0.8.1']
        - ^0.8.0 (src/PuzzleProxy.sol#2)
        - ABIEncoderV2 (src/PuzzleProxy.sol#3)
        - ^0.8.0 (src/UpgradeableProxy.sol#2)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#4)
        - ^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used

Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) is never used and should be removed
Address.functionCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#89-91) is never used and should be removed
Address.functionCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#99-105) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#118-120) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#128-137) is never used and should be removed
Address.functionDelegateCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#170-172) is never used and should be removed
Address.functionDelegateCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#180-187) is never used and should be removed
Address.functionStaticCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#145-147) is never used and should be removed
Address.functionStaticCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#155-162) is never used and should be removed
Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#64-69) is never used and should be removed
Address.verifyCallResult(bool,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#219-229) is never used and should be removed
Address.verifyCallResultFromTarget(address,bool,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#195-211) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

Pragma version^0.8.0 (src/PuzzleProxy.sol#2) allows old versions
Pragma version^0.8.0 (src/UpgradeableProxy.sol#2) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#4) allows old versions
Pragma version^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4) allows old versions
solc-0.8.1 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in UpgradeableProxy.constructor(address,bytes) (src/UpgradeableProxy.sol#26-34):
        - (success) = _logic.delegatecall(_data) (src/UpgradeableProxy.sol#31)
Low level call in Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#64-69):
        - (success) = recipient.call{value: amount}() (lib/openzeppelin-contracts/contracts/utils/Address.sol#67)
Low level call in Address.functionCallWithValue(address,bytes,uint256,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#128-137):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#135)
Low level call in Address.functionStaticCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#155-162):
        - (success,returndata) = target.staticcall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#160)
Low level call in Address.functionDelegateCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#180-187):
        - (success,returndata) = target.delegatecall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#185)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter PuzzleProxy.proposeNewAdmin(address)._newAdmin (src/PuzzleProxy.sol#20) is not in mixedCase
Parameter PuzzleProxy.approveNewAdmin(address)._expectedAdmin (src/PuzzleProxy.sol#24) is not in mixedCase
Parameter PuzzleProxy.upgradeTo(address)._newImplementation (src/PuzzleProxy.sol#29) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

PuzzleWallet.multicall(bytes[]) (src/PuzzleWallet.sol#44-60) has delegatecall inside a loop in a payable function: (success) = address(this).delegatecall(data[i]) (src/PuzzleWallet.sol#57)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#payable-functions-using-delegatecall-inside-a-loop

PuzzleWallet.setMaxBalance(uint256) (src/PuzzleWallet.sol#22-25) uses a dangerous strict equality:
        - require(bool,string)(address(this).balance == 0,Contract balance is not 0) (src/PuzzleWallet.sol#23)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dangerous-strict-equalities

PuzzleWallet.execute(address,uint256,bytes).to (src/PuzzleWallet.sol#37) lacks a zero-check on :
                - (success) = to.call{value: value}(data) (src/PuzzleWallet.sol#40)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

PuzzleWallet.multicall(bytes[]) (src/PuzzleWallet.sol#44-60) has external calls inside a loop: (success) = address(this).delegatecall(data[i]) (src/PuzzleWallet.sol#57)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation/#calls-inside-a-loop

PuzzleWallet.multicall(bytes[]) (src/PuzzleWallet.sol#44-60) uses assembly
        - INLINE ASM (src/PuzzleWallet.sol#49-51)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Pragma version^0.8.0 (src/PuzzleWallet.sol#2) allows old versions
solc-0.8.1 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in PuzzleWallet.execute(address,uint256,bytes) (src/PuzzleWallet.sol#37-42):
        - (success) = to.call{value: value}(data) (src/PuzzleWallet.sol#40)
Low level call in PuzzleWallet.multicall(bytes[]) (src/PuzzleWallet.sol#44-60):
        - (success) = address(this).delegatecall(data[i]) (src/PuzzleWallet.sol#57)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter PuzzleWallet.init(uint256)._maxBalance (src/PuzzleWallet.sol#11) is not in mixedCase
Parameter PuzzleWallet.setMaxBalance(uint256)._maxBalance (src/PuzzleWallet.sol#22) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

UpgradeableProxy.constructor(address,bytes)._logic (src/UpgradeableProxy.sol#26) lacks a zero-check on :
                - (success) = _logic.delegatecall(_data) (src/UpgradeableProxy.sol#31)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

UpgradeableProxy._implementation() (src/UpgradeableProxy.sol#51-57) uses assembly
        - INLINE ASM (src/UpgradeableProxy.sol#54-56)
UpgradeableProxy._setImplementation(address) (src/UpgradeableProxy.sol#72-81) uses assembly
        - INLINE ASM (src/UpgradeableProxy.sol#78-80)
Proxy._delegate(address) (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#22-45) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#23-44)
Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) uses assembly
        - INLINE ASM (lib/openzeppelin-contracts/contracts/utils/Address.sol#236-239)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#assembly-usage

Different versions of Solidity are used:
        - Version used: ['^0.8.0', '^0.8.1']
        - ^0.8.0 (src/UpgradeableProxy.sol#2)
        - ^0.8.0 (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#4)
        - ^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used

Address._revert(bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#231-243) is never used and should be removed
Address.functionCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#89-91) is never used and should be removed
Address.functionCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#99-105) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#118-120) is never used and should be removed
Address.functionCallWithValue(address,bytes,uint256,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#128-137) is never used and should be removed
Address.functionDelegateCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#170-172) is never used and should be removed
Address.functionDelegateCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#180-187) is never used and should be removed
Address.functionStaticCall(address,bytes) (lib/openzeppelin-contracts/contracts/utils/Address.sol#145-147) is never used and should be removed
Address.functionStaticCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#155-162) is never used and should be removed
Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#64-69) is never used and should be removed
Address.verifyCallResult(bool,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#219-229) is never used and should be removed
Address.verifyCallResultFromTarget(address,bool,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#195-211) is never used and should be removed
UpgradeableProxy._upgradeTo(address) (src/UpgradeableProxy.sol#64-67) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

Pragma version^0.8.0 (src/UpgradeableProxy.sol#2) allows old versions
Pragma version^0.8.0 (lib/openzeppelin-contracts/contracts/proxy/Proxy.sol#4) allows old versions
Pragma version^0.8.1 (lib/openzeppelin-contracts/contracts/utils/Address.sol#4) allows old versions
solc-0.8.1 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in UpgradeableProxy.constructor(address,bytes) (src/UpgradeableProxy.sol#26-34):
        - (success) = _logic.delegatecall(_data) (src/UpgradeableProxy.sol#31)
Low level call in Address.sendValue(address,uint256) (lib/openzeppelin-contracts/contracts/utils/Address.sol#64-69):
        - (success) = recipient.call{value: amount}() (lib/openzeppelin-contracts/contracts/utils/Address.sol#67)
Low level call in Address.functionCallWithValue(address,bytes,uint256,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#128-137):
        - (success,returndata) = target.call{value: value}(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#135)
Low level call in Address.functionStaticCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#155-162):
        - (success,returndata) = target.staticcall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#160)
Low level call in Address.functionDelegateCall(address,bytes,string) (lib/openzeppelin-contracts/contracts/utils/Address.sol#180-187):
        - (success,returndata) = target.delegatecall(data) (lib/openzeppelin-contracts/contracts/utils/Address.sol#185)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls
./src/. analyzed (8 contracts with 76 detectors), 73 result(s) found
```
