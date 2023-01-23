// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

contract contrived{

   //no onlyOwner modifier to prevent malicious users from calling the function
    function transferOwnership(address newOwner) public virtual {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}