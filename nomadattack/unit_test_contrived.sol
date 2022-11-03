// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./interface.sol";


contract unit_test_contrived is Test {
   
    Replica attack; 
    function setUp() public {

        attack = new Replica();
  
    }

    function testProcess() public {


        bytes32 _message = bytes32(0);
        attack.process(_message);

    }

}

contract Replica {

 mapping(bytes32 => uint256) public confirmAt;
 mapping(bytes32 => bytes32) public messages;

  function initialize (bytes32 _committedRoot) public{

      //in the fixed the version, the line is:  
      //if (_committedRoot != bytes32(0)) confirmAt[_committedRoot] = 1;
   
       //this is the buggy line, it greenlights bytes32(0)
       confirmAt[_committedRoot] = 1;
  }

  function acceptableRoot(bytes32 _root) public view returns (bool) {
        uint256 _time = confirmAt[_root];
        if (_time == 0) {
            return false;
        }
        return block.timestamp >= _time;
    }

//we simplify the function below to reproduce attack scenario 
//we ignore the cross contract function calls to avoid different compiler versions

 function process(bytes32 _message) public returns (bool _success) {
        // ensure message was meant for this domain
        bytes32 _messageHash = keccak256(abi.encodePacked(_message));

        if (acceptableRoot(messages[_messageHash])){
            return true;
        }     
    
        return false;
    }

} 