// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "forge-std/Test.sol";
//import "./interface.sol";
import {bugHandler} from "./buggy-contracts/contracts/handlers/ERC20Handler.sol";
//import {healthyHandler} from "./healthy-contracts/contracts/handlers/ERC20Handler.sol";

contract unit_test is DSTest {

    bytes32 resourceID = hex"00000000000000000000002f422fe9ea622049d6f73f81a906b9b8cff03b7f01";
    bytes memory data = hex"000000000000000000000000000000000000000000000000000000000000006900000000000000000000000000000000000000000000000a4cc799563c380000000000000000000000000000d01ae1a708614948b2b5e0b7ab5be6afa01325c7";
    bugHandler internal bugHandler;
    healthyHandler internal healthyHandler; 

    function setUp() public virtual {

        //handler takes a bridge address as a constructor
        bugHandler = new bugHandler(0x20E5E35ba29dC3B540a1aee781D0814D5c77Bce6); 

    }

    function testDeposit() public {
        bugHandler.deposit(1, resourceID, data);

    }

    function testWhitelist() public {
        bugHandler.contractWhitelist(address(0));

    }

} 