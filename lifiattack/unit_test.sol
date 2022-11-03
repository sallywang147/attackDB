// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "./interface.sol";


interface ILIFI {
    struct LiFiData {
        bytes32 transactionId;
        string integrator;
        address referrer;
        address sendingAssetId;
        address receivingAssetId;
        address receiver;
        uint256 destinationChainId;
        uint256 amount;
    }
    struct SwapData {
        address callTo;
        address approveTo;
        address sendingAssetId;
        address receivingAssetId;
        uint256 fromAmount;
        bytes callData;
    }
    struct CBridgeData {
        address receiver;
        address token;
        uint256 amount;
        uint64 dstChainId;
        uint64 nonce;
        uint32 maxSlippage;
    }
    function swapAndStartBridgeTokensViaCBridge(LiFiData memory _liFiData,SwapData[] calldata _swapData,CBridgeData memory _cBridgeData) external payable;
}

contract unit_test is DSTest {



     function setUp() public {

         //SwapData = SwapData();
     
    }

    function testSwap() public{

            ILIFI.LiFiData memory _lifiData = ILIFI.LiFiData({
            transactionId: 0x1438ff9dd1cf9c70002c3b3cbec9c4c1b3f9eb02e29bcac90289ab3ba360e605,
            integrator: "li.finance",
            referrer: 0x0000000000000000000000000000000000000000,
            sendingAssetId: 0xdAC17F958D2ee523a2206206994597C13D831ec7,
            receivingAssetId: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 
            receiver: 0x878099F08131a18Fab6bB0b4Cfc6B6DAe54b177E,
            destinationChainId: 42161,
            amount: 50000000
        });
        ILIFI.SwapData[] memory _swapData = new ILIFI.SwapData[](38);
        _swapData[0] = ILIFI.SwapData({
            approveTo: 0xDef1C0ded9bec7F1a1670819833240f027b25EfF,
            callData: hex"d9627aa400000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000002faf0800000000000000000000000000000000000000000000000000000000002625a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", 
            // sellToUniswap(address[],uint256,uint256,bool)
            // {
            //     "tokens":[
            //     0:"0xdac17f958d2ee523a2206206994597c13d831ec7"
            //     1:"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
            //     ]
            //     "sellAmount":"50000000"
            //     "minBuyAmount":"40000000"
            //     "isSushi":false
            // }
            callTo: 0xDef1C0ded9bec7F1a1670819833240f027b25EfF,
            fromAmount: 50000000,
            receivingAssetId: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            sendingAssetId: 0xdAC17F958D2ee523a2206206994597C13D831ec7 // fromAssetId
            // if (!LibAsset.isNativeAsset(fromAssetId) && LibAsset.getOwnBalance(fromAssetId) < fromAmount) {
            //     LibAsset.transferFromERC20(_swapData.sendingAssetId, msg.sender, address(this), fromAmount);
            // }

            // if (!LibAsset.isNativeAsset(fromAssetId)) {
            //     LibAsset.approveERC20(IERC20(fromAssetId), _swapData.approveTo, fromAmount);
            // }

            // // solhint-disable-next-line avoid-low-level-calls
            // (bool success, bytes memory res) = _swapData.callTo.call{ value: msg.value }(_swapData.callData);
        });         
    }

}