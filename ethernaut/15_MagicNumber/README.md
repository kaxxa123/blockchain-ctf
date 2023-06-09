# Magic Number

[Magic Number](https://ethernaut.openzeppelin.com/level/0xFe18db6501719Ab506683656AAf2F80243F8D0c0)


<BR />

## [Ethereum smart contract creation code](https://www.rareskills.io/post/ethereum-contract-creation-code)

* A smart contract is deployed by sending a transaction to the 0x0 address

* The transaction data is laid out as follows: <BR />
    ``Init Code`` | ``Runtime Code`` | ``Constructor Parameters``

* The EVM starts from the ``Init Code`` whose execution stores the runtime code to the blockchain

* The order of ``Runtime Code`` and ``Constructor Parameters`` need not be like that. It's just convention.

* The simplest contract is one which just an empty payable constructor.


Article Code: <BR />
|`00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10` |
|--------------------------------------------------|
|_`60 80 60 40 52 60 3f 80 60 11 60 00 39 60 00 f3 fe`_ |
|__`60 80 60 40 52 60 00 80 fd fe a2 64 69 70 66 73`__ |
|__`58 22 12 20 `__ `d0 32 48 cf 82 92 89 31 c1 58 55 17` | 
|`24 be ba c6 7e 40 7e 6f 3f 32 4f 93 0c 4c f1 c3` |
|`6e 16 32 87 64 73 6f 6c 63 43 00 08 11 00 33`    |



Hardhat Compilation bytecode of ``Simplest.sol``: <BR />

|`00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F` |
|--------------------------------------------------|
|_`60 80 60 40 52 60 3f 80 60 11 60 00 39 60 00 f3 fe`_ | 
|__`60 80 60 40 52 60 00 80 fd fe a2 64 69 70 66 73`__ |
|__`58 22 12 20 `__ `8d 57 03 e1 d4 4d e5 a5 2a 89 95 63` |
|`2b 69 3a e9 3d 53 41 ab 55 19 37 2e ff 54 58 19` |
|`2e a6 6a b6 64 73 6f 6c 63 43 00 08 12 00 33`    |


Referring to the [EVM opcodes table](https://www.evm.codes/) to decode the init code:  <BR />

|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------------|-------|
|`60 80` | `PUSH1 80`    | `[80]`                    |       |
|`60 40` | `PUSH1 40`    | `[40, 80]`                |       |
|`52`    | `MSTORE`      | `[]`                      | Store the value `80` as a 32-bit value at offset `40` to memory  |

|`00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F` |
|--------------------------------------------------|
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80` |


|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------|-------|
|`60 3f` | `PUSH1 3f`    | `[3f]`              |       |
|`80`    | `DUP1`        | `[3f, 3f]`          | Duplicate top value `3f` |
|`60 11` | `PUSH1 11`    | `[11, 3f, 3f]`      |       |
|`60 00` | `PUSH1 00`    | `[00, 11, 3f, 3f]`  |       |
|`39`    | `CODECOPY`    | `[3f]`              | Copy the code to memory offset `00` from this code stream starting at offset `11`, for a length of `3f` |

|`00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F` |
|--------------------------------------------------|
|__`60 80 60 40 52 60 00 80 fd fe a2 64 69 70 66 73`__ |
|__`58 22 12 20 `__ `8d 57 03 e1 d4 4d e5 a5 2a 89 95 63` |
|`2b 69 3a e9 3d 53 41 ab 55 19 37 2e ff 54 58 19` |
|`2e a6 6a b6 64 73 6f 6c 63 43 00 08 12 00 33 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00` |
|`00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 80` |




|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------|-------|
|`60 00` | `PUSH1 00`    | `[00, 3f]`          |       |
|`f3`    | `RETURN`      | `[]`                | Return the data stored in memory starting from offset `00` with length `3f`. |
|`fe`    | `INVALID`     | `[]`                |       |


Return Data:
|`00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F` |
|--------------------------------------------------|
|__`60 80 60 40 52 60 00 80 fd fe a2 64 69 70 66 73`__ |
|__`58 22 12 20 `__ `8d 57 03 e1 d4 4d e5 a5 2a 89 95 63` |
|`2b 69 3a e9 3d 53 41 ab 55 19 37 2e ff 54 58 19` |
|`2e a6 6a b6 64 73 6f 6c 63 43 00 08 12 00 33` |


To see the code in action run this [here](https://www.evm.codes/playground). Note it's not important what code we pass after ``INVALID``. What'simportant is that we have the same code size.

```
PUSH1 0x80
PUSH1 0x40
MSTORE
PUSH1 0x3F
DUP1
PUSH1 0x11
PUSH1 0x00
CODECOPY
PUSH1 0x00
RETURN
INVALID
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
PUSH1 0x40 
PUSH1 0x00 
PUSH1 0x80 
INVALID
```

* If the contract had to have a non-payable constuctor, the `init code` would include a check that reverts in case the caller passes any Wei on deployment. The ``runtime code`` doesn't change, since this check is part of the constructor.

* In an empty contractor the ``runtime code`` is not empty because of metadata introduced by the compiler.

* If we look at the runtime code we see that it just reverts

|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------------|-------|
|`60 80` | `PUSH1 80`    | `[80]`                    |       |
|`60 40` | `PUSH1 40`    | `[40, 80]`                |       |
|`52`    | `MSTORE`      | `[]`                      | Store the value `80` as a 32-bit value at offset `40` to memory  |
|`60 00` | `PUSH1 00`    | `[00]`                    |       |
|`80`    | `DUP1`        | `[00, 00]`                | Duplicate top value `00` |
|`fd`    | `REVERT`      | `[]`                      | Revert and return memory data at offset `00` and with length `00`. (no return) |
|`fe`    | `INVALID`     | `[]`                |       |

* The solidity compiler 0.8.18 adds support for ``--no-cbor-metadata`` which eliminates injection of this metadata.

<BR />


## Attack Prepare

Based on this, we can write an intial Attack contrack with just a fallback and that always returns 42. This won't be good enough since the compiled output will be too large. But we can start by seeing if this works:

```BASH
npx hardhat compile
npx hardhat console
```


```JS
accounts = await ethers.getSigners()
accounts[0].address

AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy()

SolverFactory = await ethers.getContractFactory("Solver")
solve = await SolverFactory.attach(attack.address)

await solve.whatIsTheMeaningOfLife()
```

Now that we know that this works we can look at the compiled output and look for our fallback code.

```
"bytecode": "0x608060405260458060116000396000f3fe6080604052602a60005260206000f3fea26469706673582212207b128e42124e024ef3487e07bd58cd7b5cb84e21a37c2c1a8d62a1acaf16950164736f6c63430008120033",

"deployedBytecode":
"0x6080604052602a60005260206000f3fea26469706673582212207b128e42124e024ef3487e07bd58cd7b5cb84e21a37c2c1a8d62a1acaf16950164736f6c63430008120033",
```

``Init Code``: <BR />
0x608060405260458060116000396000f3fe

``Runtime Code``: <BR />
0x6080604052602a60005260206000f3fea26469706673582212207b128e42124e024ef3487e07bd58cd7b5cb84e21a37c2c1a8d62a1acaf16950164736f6c63430008120033

Looking at the first 10 opcodes...

|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------------|-------|
|`60 80` | `PUSH1 80`    | `[80]`                    |       |
|`60 40` | `PUSH1 40`    | `[40, 80]`                |       |
|`52`    | `MSTORE`      | `[]`                      | Store the value `80` as a 32-bit value at offset `40` to memory  |
|`60 2a` | `PUSH1 2a`    | `[2a]`                    |       |
|`60 00` | `PUSH1 00`    | `[00, 2a]`                |       |
|`52`    | `MSTORE`      | `[]`                      | Store the value `2a` as a 32-bit value at offset `00` to memory  |
|`60 20` | `PUSH1 20`    | `[20]`                    |       |
|`60 00` | `PUSH1 00`    | `[00, 20]`                |       |
|`f3`    | `RETURN`      | `[]`                      | Return the data stored in memory starting from offset `00` with length `20`. |
|`fe`    | `INVALID`     | `[]`                      |       |


Working with this doesn't work. The challenge says 10 opcodes but it actually means 10 bytes so we have to count the operands as well!
We shorting the code further as follows:


|byte(s) | opcode operand| stack after [top, bottom] | Notes |
|--------|---------------|---------------------------|-------|
|`60 2a` | `PUSH1 2a`    | `[2a]`                    |       |
|`60 40` | `PUSH1 40`    | `[40, 2a]`                |       |
|`52`    | `MSTORE`      | `[]`                      | Store the value `2a` as a 32-bit value at offset `40` to memory  |
|`60 20` | `PUSH1 20`    | `[20]`                    |       |
|`60 40` | `PUSH1 40`    | `[40, 20]`                |       |
|`f3`    | `RETURN`      | `[]`                      | Return the data stored in memory starting from offset `40` with length `20`. |


Thus we only seem to need the first `0x0a` bytes: <BR />
`00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f` <BR />
`60 2a 60 40 52 60 20 60 40 f3`

Setting ``Init Code`` to only reference these lines of code: <BR />
`60 80 60 40 52 60 `_`0a`_` 80 60 11 60 00 39 60 00 f3 fe`

```
"bytecode": 
0x6080604052600a8060116000396000f3fe602a60405260206040f3

"deployedBytecode": 
0x602a60405260206040f3
```

We now directly edit the compiled output for ``Attack.sol`` and apply it to solve the live challenge.

<BR />


## LIVE Attack

```BASH
npx hardhat console --network goerli
```


```JS
accounts = await ethers.getSigners()
accounts[0].address

AttackFactory = await ethers.getContractFactory("Attack")
attack = await AttackFactory.connect(accounts[0]).deploy()
attack.address
//Check the bytecode on etherscan.io
//'0x6846e3B1BBd4e09da9C8AE1B42fDa330547B6e94'

//Test it...
SolverFactory = await ethers.getContractFactory("Solver")
solve = await SolverFactory.attach(attack.address)
await solve.whatIsTheMeaningOfLife()

//Try attack...
MagicFactory = await ethers.getContractFactory("MagicNum")
magic = await MagicFactory.attach('0xC63BA2aCE8BBf7E4151062bEf083cC34DA896FA1')

await magic.connect(accounts[0]).setSolver(attack.address)
await magic.solver()
```

<BR />


## Other Resources

[EIP-1167: Minimal Proxy Standard with Initialization Clone pattern](https://www.rareskills.io/post/eip-1167-minimal-proxy-standard-with-initialization-clone-pattern)

[VIDEO - If we wanted to cheat...](https://youtu.be/0qQUhsPafJc)


