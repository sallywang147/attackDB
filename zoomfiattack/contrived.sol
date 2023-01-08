// SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.8.6;

interface IUSD {
  function batchToken(address[] calldata _addr, uint256[]calldata _num, address token)external ;
 function swapTokensForExactTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) ;
    function buy(uint256) external ;
    function sell(uint256)external ;
    function getReserves() external  view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    //The price of Zoom/USDT will raise after calling the pair function sync
    function sync ()external ;
}