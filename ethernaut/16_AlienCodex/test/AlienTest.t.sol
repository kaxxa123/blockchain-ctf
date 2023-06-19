// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

// forge test -vvv

// Looks like this does not support v0.5.0
// So we cannot use it!
// import "forge-std/Test.sol";

import "../src/AlienCodex.sol";

// contract AlienTest is Test {
contract AlienTest {

    AlienCodex public theAlien;

    function setUp() public {
        theAlien = new AlienCodex();
    }

    function test_AddRecord() public {
        theAlien.makeContact();
        require(theAlien.contact());

        bytes32 valWrite = bytes32(uint256(1311768467294899695));
        theAlien.record(valWrite);

        bytes32 valRead = theAlien.codex(0);
    }

    function testFail_AddRecordWithNoContact() public {
        bytes32 valWrite = bytes32(uint256(1311768467294899695));
        theAlien.record(valWrite);
    }

    function testFail_ReadBeyondArrayLimit() public {
        theAlien.makeContact();
        require(theAlien.contact());

        bytes32 valWrite = bytes32(uint256(1311768467294899695));
        theAlien.record(valWrite);

        bytes32 valRead = theAlien.codex(1);
    }

    function test_ReadBeyondArrayLimit() public {
        theAlien.makeContact();
        require(theAlien.contact());

        theAlien.retract();
        bytes32 valRead = theAlien.codex(1);
    }
}