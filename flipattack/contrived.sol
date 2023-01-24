/**
 *Submitted for verification at Etherscan.io on 2022-07-05
*/

pragma solidity ^0.8.15;
// SPDX-License-Identifier: MIT


contract contrived{

//lacks onlyOwner Modifier 
    function ownerWithdrawAllTo(address toAddress) public  {
        (bool success, ) = toAddress.call{value: address(this).balance}("");
        require(success, "Failed to withdraw funds.");
    }
}