// SPDX-License-Identifier: MIT
pragma solidity >=0.5.1 <0.8.12;

import "./PiggyBankDb.sol";

contract PiggyBankRouter is PiggyBankDb {
    address currentAddress;

    constructor(address _currentAddress) {
        currentAddress = _currentAddress;
    }

    function upgrade(address _newAddress) public {
        currentAddress = _newAddress;
    }
    //Fallback Function
    //Redirects to currentAddress
    fallback () payable external {
        address implimentation = currentAddress;
        require(currentAddress != address(0));
        bytes memory data = msg.data;

        assembly {
            let result := delegatecall(gas(), implimentation, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize()
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}

        }
    }
}
