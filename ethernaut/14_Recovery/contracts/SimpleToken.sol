// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleToken {

    string public name;
    mapping (address => uint) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // AlexZ: Can be used to ZERO anyone's balance
    // Just set the address of the target and the _amount to zero
    function transfer(address _to, uint _amount) public { 
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;

        //AlexZ: Here we are replacing the balance NOT incrementing it
        balances[_to] = _amount;
    }

    //AlexZ: Anyone can call this
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}