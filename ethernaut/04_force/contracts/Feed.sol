// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Feed {

    address payable public target;

    constructor(address payable trg) payable {
        target = trg;
    }

    function die() public {
        selfdestruct(target);
    }
}
