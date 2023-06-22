// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Attack.sol";
import "../src/Shop.sol";

contract TestAttack is Test {
    Shop public     shopCtr;
    Attack public   attackCtr;

    function setUp() public {
        shopCtr = new Shop();
        attackCtr = new Attack();
    }

    function test_BuyAtZero() external {
        attackCtr.doAttack(address(shopCtr));

        assertTrue(shopCtr.isSold());
        assertEq(shopCtr.price(), 0);
    }
}
