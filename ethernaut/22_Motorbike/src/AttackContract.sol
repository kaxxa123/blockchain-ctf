// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

contract AttackContract {
    address payable owner;
    constructor() public {
        owner = msg.sender;
    }

    function boom() public {
        selfdestruct(owner);
    }
}