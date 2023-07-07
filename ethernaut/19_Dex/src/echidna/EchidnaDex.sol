// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Dex.sol";
import "../SwappableToken.sol";

contract EchidnaDex {

    SwappableToken tokenA;
    SwappableToken tokenB;
    Dex tokenDex;

    constructor() {
        tokenDex = new Dex();
        tokenA = new SwappableToken(address(this), "Token1", "TOK1", 100_000);
        tokenB = new SwappableToken(address(this), "Token2", "TOK2", 100_000);

        tokenA.transfer(address(tokenDex), 100);
        tokenB.transfer(address(tokenDex), 100);
        tokenA.transfer(address(0x10000), 10);
        tokenB.transfer(address(0x10000), 10);
        tokenA.transfer(address(0x20000), 10);
        tokenB.transfer(address(0x20000), 10);
        tokenA.transfer(address(0x30000), 10);
        tokenB.transfer(address(0x30000), 10);

        tokenDex.setTokens(address(tokenA), address(tokenB));
    }

    // Invariant:
    //      When swapped amount is greater than zero
    //          the swap price should never be zero.
    function invariantNeverFreeSwap(uint amount) public view  {
        assert ( (amount == 0) || 
                 (tokenDex.getSwapPrice(address(tokenA), address(tokenB), amount) > 0));
    }

    // Performs swaps to force changes in DEX balances
    function swap(bool order, uint amount) public {
        if (order) {
            uint swapAmnt = (amount % tokenA.balanceOf(address(msg.sender))) + 1;
            tokenA.approve(address(tokenDex), swapAmnt);
            tokenDex.swap(address(tokenA), address(tokenB), swapAmnt);
        }
        else {
            uint swapAmnt = (amount % tokenB.balanceOf(address(msg.sender))) + 1;
            tokenB.approve(address(tokenDex), swapAmnt);
            tokenDex.swap(address(tokenB), address(tokenA), swapAmnt);
        }
    }
}
