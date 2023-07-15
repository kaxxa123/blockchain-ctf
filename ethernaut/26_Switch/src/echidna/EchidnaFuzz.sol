// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Switch.sol";

// Test whether switch can be turned on.
contract EchidnaFuzz {

    Switch singlePole;

    // Setup to replicate CTF configuration:
    constructor() {
        singlePole = new Switch();
    }

    function invariant_NeverOn() public view {
        assert(singlePole.switchOn() == false);
    }
}