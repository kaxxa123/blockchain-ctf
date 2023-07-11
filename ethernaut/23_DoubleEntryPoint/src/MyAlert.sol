// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LegacyToken.sol";
import "./Forta.sol";
import "./Interfaces.sol";

contract MyAlert is IDetectionBot {

    address vault;
    address forta;

    constructor(address _vault, address _forta) {
        vault = _vault;
        forta = _forta;
    }

    function handleTransaction(address user, bytes calldata msgData) external {
        (, , address origSender) = abi.decode(msgData[4:], (address,uint256,address));

        if (vault == origSender) {
            Forta(forta).raiseAlert(user);
        }
    }    
}