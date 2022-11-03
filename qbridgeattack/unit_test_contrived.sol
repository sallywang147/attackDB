// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "forge-std/Test.sol";
import "./interface.sol";
import "./contrived.sol";
//import {healthyHandler} from "./healthy-contracts/contracts/handlers/ERC20Handler.sol";


contract unit_test is DSTest {

    
     contrived attack;

    function setUp() public {

        //handler takes a bridge address as a constructor
        attack = new contrived(); 

    }


    function testWhitelist() public {
        attack.contractWhitelist(address(0));

    }

} 