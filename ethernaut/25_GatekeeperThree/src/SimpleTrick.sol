// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GatekeeperThree.sol";

contract SimpleTrick {
    GatekeeperThree public target;
    address public trick;
    uint private password = block.timestamp;

    constructor (address payable _target) {
        target = GatekeeperThree(_target);
    }
        
    // AlexZ: Just read the password from the contract storage.
    function checkPassword(uint _password) public returns (bool) {
        if (_password == password) {
        return true;
        }
        password = block.timestamp;
        return false;
    }
        
    function trickInit() public {
        trick = address(this);
    }
    
    //AlexZ: We don't care about this.
    function trickyTrick() public {
        if (address(this) == msg.sender && address(this) != trick) {
            target.getAllowance(password);
        }
    }
}

