// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../CryptoVault.sol";
import "../DoubleEntryPoint.sol";
import "../LegacyToken.sol";
import "../Forta.sol";
import "../Interfaces.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

// Test whether balance can be withdrawn from the underlying token
// of the CryptoVault
contract EchidnaFuzz {

    uint256 constant    EXPECT_BALNCE = 100 ether;

    DoubleEntryPoint public tokenUnder;
    LegacyToken public tokenLega;
    Forta public forta;
    CryptoVault public vault;

    // Setup to replicate CTF configuration:
    constructor() {
        forta = new Forta();
        vault = new CryptoVault(address(0x3000));

        tokenLega = new LegacyToken();
        tokenLega.mint(address(vault), EXPECT_BALNCE);

        tokenUnder = new DoubleEntryPoint(address(tokenLega), 
                                    address(vault), 
                                    address(forta), 
                                    address(0x3000));

        tokenLega.delegateToNewContract(tokenUnder);
        vault.setUnderlying(address(tokenUnder));
    }

    function invariantUnderBalance() public  view {
        assert(EXPECT_BALNCE == tokenUnder.balanceOf(address(vault)));
    }
}
