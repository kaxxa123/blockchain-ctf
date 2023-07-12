// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CryptoVault.sol";
import "../src/DoubleEntryPoint.sol";
import "../src/LegacyToken.sol";
import "../src/Forta.sol";
import "../src/Interfaces.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

// Test whether balance can be withdrawn from the underlying token
// of the CryptoVault
contract InvariantTest is Test {

    uint256 constant    EXPECT_BALNCE = 100 ether;

    DoubleEntryPoint public tokenUnder;
    LegacyToken public tokenLega;
    Forta public forta;
    CryptoVault public vault;

    // Setup to replicate CTF configuration:
    function setUp() external {
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

        // Avoid possibility of any additional transfers 
        // from the underlying token.
        excludeContract(address(tokenUnder));
    }

    function testShow() public {
        console.log("CryptoVault underlying token: ", address(vault.underlying()));
        console.log("Swept token recipient:        ", vault.sweptTokensRecipient());   

        ERC20 delegator = ERC20(tokenUnder.delegatedFrom());
        console.log("Delegator Token:              ", delegator.name());
        console.log("Legacy token Vault balance:   ", delegator.balanceOf(address(vault)));

        LegacyToken legacy = LegacyToken(address(delegator));
        console.log("Legacy->Delegate Token:       ", address(legacy.delegate()));
        console.log("Underlying token Vault balance:", tokenUnder.balanceOf(address(vault)));

        vm.prank(address(0x123456));
        vault.sweepToken(legacy);
        console.log();
        console.log("Legacy token Vault balance:   ", delegator.balanceOf(address(vault)));
        console.log("Underlying token Vault balance:", tokenUnder.balanceOf(address(vault)));
    }

    // forge test --match-contract InvariantTest  --match-test invariant_UnderBalance -vvv
    function invariant_UnderBalance() public {
        assertEq(EXPECT_BALNCE, tokenUnder.balanceOf(address(vault)));
    }
}