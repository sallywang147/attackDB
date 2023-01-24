//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;


contract contrived {

   function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if (!allowedAddresses[msg.sender] && !allowedAddresses[recipient]) {
            require(block.timestamp > transferBlockTime, "Transfers have not been enabled yet.");
        }
   } 
    //anyone can call the burn function 

    function burn(address account, uint256 _amount) public {
        _transferFrom(account, DEAD, _amount);

        emit burnTokens(account, _amount);
    }
} 