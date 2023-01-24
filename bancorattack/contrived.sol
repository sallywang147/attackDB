/**
 *Submitted for verification at Etherscan.io on 2020-06-16
*/

// File: contracts/token/interfaces/IERC20Token.sol

pragma solidity 0.4.26;

contract contrived{

//this function should not be public: 
//This essentially allowed anyone to transfer tokens which were approved only for the contract to transfer
    function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) public {
       execute(_token, abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));
    }
}