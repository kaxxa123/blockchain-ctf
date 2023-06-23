// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin/token/ERC20/ERC20.sol";

contract SwappableToken is ERC20 {
    address private _dex;
    constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
            _mint(msg.sender, initialSupply);
            _dex = dexInstance;
    }

    // Anyone can approve anyone else's balance!
    // We just cannot approve the dex's balance.
    function approve(address owner, address spender, uint256 amount) public {
        require(owner != _dex, "InvalidApprover");
        super._approve(owner, spender, amount);
    }
}

