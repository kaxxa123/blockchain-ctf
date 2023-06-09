// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Attack {
    constructor() payable {
    }

    fallback() external payable {
       assembly {
            // Push 42 = 0x2A onto the stack
            // and copy it to memory
            mstore(0, 0x2A)
            
            // Return the value on the stack
            return(0, 0x20)
        }
    }
}