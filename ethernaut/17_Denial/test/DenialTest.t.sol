// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Denial.sol";
import "../src/Attack.sol";

contract DenialTest is Test {

    Denial public denialCtr;
    Attack public attackCtr;

    function setUp() public {
        denialCtr = new Denial();
        attackCtr = new Attack();

        prepare();
    }

    //Setup state of Denial contract for testing
    function prepare() private {
        //Set Attack contract as the partner
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

    function test_AllowedTransfers() public {

        // Test withdrawing
        uint256 ownerBalanceSt = denialCtr.owner().balance;
        console.log("Owner Balance Start: ", ownerBalanceSt);

        denialCtr.withdraw{gas: 1100000}();

        uint256 ownerBalanceEn = denialCtr.owner().balance;
        console.log("Owner Balance Start: ", ownerBalanceEn);
        
        assertNotEq(ownerBalanceSt,ownerBalanceEn);
    }    
}