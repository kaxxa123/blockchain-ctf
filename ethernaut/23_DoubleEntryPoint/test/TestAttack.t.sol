// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CryptoVault.sol";
import "../src/DoubleEntryPoint.sol";
import "../src/LegacyToken.sol";
import "../src/Forta.sol";
import "../src/Interfaces.sol";
import "../src/MyAlert.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract TestAttack is Test, IDetectionBot {

    string constant public PROJECT_ID = "PROJECT_ID";
    address payable public constant  DET    = payable(0x20153a5D326e3f23d81675Be12B23b06808033F7);
    address payable public constant  CVAULT = payable(0x8Abb5A542164531c23B02b044e73E1ad5671a2EE);
    address payable public constant  FORTA  = payable(0x231acfe8DB72b9ca59838E2D9AE0695b663f407d);
    address payable public constant  DET_DELEGATEFROM = payable(0x957D7bed797b040700fD2f2AB40A09c07aAbc0f3);
    address payable public constant  PLAYER = payable(0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18);

    MyAlert alert;

    function setUp() public {
        fork(9_325_837);
        alert = new MyAlert(CVAULT, FORTA);
    }

    function testFail_RaisedAlert() public {
        CryptoVault cvault = CryptoVault(CVAULT);
        console.log("CryptoVault underlying token: ", address(cvault.underlying()));
        console.log("Swept token recipient:        ", cvault.sweptTokensRecipient());   

        ERC20 delegator = ERC20(DET_DELEGATEFROM);
        console.log("Delegator Token:              ", delegator.name());
        console.log("Legacy token Vault balance:   ", delegator.balanceOf(CVAULT));

        LegacyToken legacy = LegacyToken(DET_DELEGATEFROM);
        console.log("Legacy->Delegate Token:       ", address(legacy.delegate()));

        DoubleEntryPoint det = DoubleEntryPoint(DET);
        console.log("Underlying token Vault balance:", det.balanceOf(CVAULT));

        vm.prank(PLAYER);
        Forta(FORTA).setDetectionBot(address(this));
        // Forta(FORTA).setDetectionBot(address(alert));

        vm.prank(address(0x123456));
        cvault.sweepToken(legacy);
        console.log();
        console.log("Legacy token Vault balance:   ", delegator.balanceOf(CVAULT));
        console.log("Underlying token Vault balance:", det.balanceOf(CVAULT));
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address,uint256,address));
        console.log();
        console.log("* * * * * *");
        console.log(vm.toString(msgData));
        console.log("length:     ",msgData.length);
        console.log("user:       ",user);
        console.log("to:         ",to);
        console.log("value:      ",value);
        console.log("origSender: ",origSender);
        console.log("* * * * * *");
        console.log();

        if (CVAULT == origSender) {
            Forta(FORTA).raiseAlert(user);
        }
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