// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GatekeeperTwo.sol";

contract Attack {

    constructor(address addr) {
        uint64 encodedAddr  = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 gateKey      = bytes8(uint64(encodedAddr) ^ 0xFFFFFFFFFFFFFFFF);
        
        GatekeeperTwo(addr).enter(gateKey);
    }
}