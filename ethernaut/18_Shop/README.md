# Shop

[Shop](https://ethernaut.openzeppelin.com/level/0xCb1c7A4Dee224bac0B47d0bE7bb334bac235F842)

`Shop` calls untrusted code provided by the caller contract.

<BR />

## Attack Test


```BASH
forge test -vvvv
```

<BR />


# Live Attack

```BASH
# Create Ethernaut Shop instance and...
# configure Shop contract address at .env_public

# Deploy attack contract
./attackDeploy.sh

# Configure Attack contract address at .env_public

# Run Attack
./attackDo.sh
```

<BR />
