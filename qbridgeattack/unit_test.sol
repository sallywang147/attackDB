// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "forge-std/Test.sol";
import "./interface.sol";



contract unit_test is DSTest {

   
    ERC20Handler  bugHandler;


    function setUp() public virtual {

        //handler takes a bridge address as a constructor
         bugHandler = new ERC20Handler(); 

    }

   // function testDeposit() public {
   //     bugHandler.deposit(1, resourceID, data);

  //  }

    function testDeposit() public {

        bytes32 resourceID = hex"00000000000000000000002f422fe9ea622049d6f73f81a906b9b8cff03b7f01";
        bytes calldata data = hex"000000000000000000000000000000000000000000000000000000000000006900000000000000000000000000000000000000000000000a4cc799563c380000000000000000000000000000d01ae1a708614948b2b5e0b7ab5be6afa01325c7";
        bugHandler.deposit(resourceID, address(0), data);

    }

} 

contract ERC20Handler {
   
    function deposit(
        bytes32 resourceID,
        address depositer,
        bytes   calldata data
    ) public returns (bytes memory) {
        uint256        amount;
        (amount) = abi.decode(data, (uint));

        address tokenAddress = _resourceIDToTokenContractAddress[resourceID];
        require(_contractWhitelist[tokenAddress], "provided tokenAddress is not whitelisted");

    }

}