// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../CoinFlip.sol";

// Invariant testing with echidna
// 
// $ solc-select use 0.8.0
// $ echidna-test  ./contracts/echidna/EchidnaCoinFlip.sol  \
//          --contract EchidnaCoinFlip  \
//          --corpus-dir ./coverage \
//          --test-mode assertion
contract EchidnaCoinFlip is CoinFlip {
    
    function testLastHashStorage(bool _guess) public {
        uint blockHash = uint256(blockhash(block.number - 1));
        flip(_guess);

        assert(blockHash == lastHash);
    }
}