// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Switch.sol";

contract InvariantTest is Test {

    Switch singlePole;

    function setUp() external {
        singlePole = new Switch();

        console.log("Switch address: ", address(singlePole));

        // Exclude the Switch contract address from submitting 
        // transactions as an EOA. This would indeed turn the 
        // switch on. But that cannot happen in real live.
        excludeSender(address(singlePole));
    }

    function invariant_NeverOn() public {
        assertEq(singlePole.switchOn(), false);
    }
}