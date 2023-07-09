// SPDX-License-Identifier: MIT
pragma solidity <0.7.0;

import "../Engine.sol";
import "../Motorbike.sol";
import "openzeppelin-contracts/utils/Address.sol";

contract MotorbikeEx is Motorbike {

    constructor(address _logic) public Motorbike(_logic) {
    }

    // Returns an `AddressSlot` with member `value` located at `slot`.
    function getImpl() public view returns (address) {
        AddressSlot storage addr_slot = _getAddressSlot(_IMPLEMENTATION_SLOT);
        return addr_slot.value;
    }
}

contract EchidnaFuzz {

    Engine engine;
    MotorbikeEx motor;

    constructor() public {
        engine = new Engine();
        motor = new MotorbikeEx(address(engine));
    }

    // Invariant: Implementation address should always be a contract 
    //            aka should always have code associated to it.
    function invariantImplIsContract() public view {
        address impl = motor.getImpl();
        assert(Address.isContract(impl));
    }

    // Invariant: Implementation contract should not be initializable..
    function invariantImplNotInitialized() public view {
        assert(engine.horsePower() == 0);
    }
}