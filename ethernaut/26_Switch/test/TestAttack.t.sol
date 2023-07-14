// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract TestAttack is Test {

    bytes32 public readValue;

    constructor() {
    }

    function showCallData(bytes memory bval) public {
        bytes32[1] memory selector;
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }

        readValue = selector[0];
        console.log("Value: ", vm.toString(readValue));
    }

    function testSwitchOn() public {
        bytes memory myParam  =  hex"331255AA";

        bytes memory myBytes  = abi.encodeWithSignature("showCallData(bytes)", myParam);
        (bool success, ) = address(this).call(myBytes);

        console.log("showCallData result: ", success);

    }
}