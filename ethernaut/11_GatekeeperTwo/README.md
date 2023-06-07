# Gatekeeper Two

[Gatekeeper Two](https://ethernaut.openzeppelin.com/level/0xf59112032D54862E199626F55cFad4F8a3b0Fce9)


## Notes

1. ``gateTwo`` => The Attack must be carried out from the contract ctx.

1. Contract: ``0x95B5086CafFaA40c6b7686FFb08EB3F42E50A4d2``

<BR />

## Test Attack
```BASH
npx hardhat compile
npx hardhat console
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

//Deploy GatekeeperTwo test contract
GateFactory = await ethers.getContractFactory("GatekeeperTwo")
gate = await GateFactory.connect(accounts[0]).deploy()
await gate.entrant()

//Deploy Attack test contract
AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy(gate.address)
await gate.entrant()
```

<BR />

## Live Attack
```BASH
npx hardhat console --network goerli
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

//Connect to GatekeeperOne contract on-chain
GateFactory = await ethers.getContractFactory("GatekeeperTwo")
gate = await GateFactory.attach("0x95B5086CafFaA40c6b7686FFb08EB3F42E50A4d2")
await gate.entrant()

//Deploy Attack test contract
AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy(gate.address)
await gate.entrant()
```