  
  // SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.6.0 <0.8.0;

import "./openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./openzeppelin/contracts/math/SafeMath.sol";
import "./openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "./openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// import "hardhat/consolse.sol";
import "./libraries/IMonoXPool.sol";
import "./libraries/IWETH.sol";
import "./libraries/MonoXLibrary.sol";

//this contract is merely for annotation: it won't compile 
  contract Monoswap{
// view func for removing liquidity
  //bug: in this remove liquidity function, there's no check on msg.sender or to addresses,
  //it means that any address of msg.sender or to can remove the liquidity of a pool 
  function _removeLiquidity (address _token, uint256 liquidity,
        address to) view public returns(
        uint256 poolValue, uint256 liquidityIn, uint256 vusdOut, uint256 tokenOut) {
        
        require (liquidity>0, "MonoX:BAD_AMOUNT");
        uint256 tokenBalanceVusdValue;
        uint256 vusdCredit;
        uint256 vusdDebt;
        PoolInfo memory pool = pools[_token];
        (poolValue, tokenBalanceVusdValue, vusdCredit, vusdDebt) = getPool(_token);
        uint256 _totalSupply = monoXPool.totalSupplyOf(pool.pid);
         
        //buggy line: there's no check performed on to, so anyone can manipuate the to addresses
        liquidityIn = monoXPool.balanceOf(to, pool.pid)>liquidity?liquidity:monoXPool.balanceOf(to, pool.pid);
        uint256 tokenReserve = IERC20(_token).balanceOf(address(monoXPool));
        
        if(tokenReserve < pool.tokenBalance){
          tokenBalanceVusdValue = tokenReserve.mul(pool.price)/1e18;
        }
    
        if(vusdDebt>0){
          tokenReserve = (tokenBalanceVusdValue.sub(vusdDebt)).mul(1e18).div(pool.price);
        }
    
        // if vusdCredit==0, vusdOut will be 0 as well
        vusdOut = liquidityIn.mul(vusdCredit).div(_totalSupply);
    
        tokenOut = liquidityIn.mul(tokenReserve).div(_totalSupply);
    
      }
    
      function swapExactTokenForETH(
            address tokenIn,
            uint amountIn,
            uint amountOutMin,
            address to,
            uint deadline
          ) external virtual ensure(deadline) returns (uint amountOut) {
            IMonoXPool monoXPoolLocal = monoXPool;
            amountOut = swapIn(tokenIn, WETH, msg.sender, address(monoXPoolLocal), amountIn);
            require(amountOut >= amountOutMin, 'MonoX:INSUFF_OUTPUT');
            monoXPoolLocal.withdrawWETH(amountOut);
            monoXPoolLocal.safeTransferETH(to, amountOut);
          }
    
    //where' the bug? in the  _updateTokenInfo() function, when tokenIn and tokenOut are the same token
    //tokenOut can override tokenIn 
    //the troot cause: the price update operation of the output token will overwrite the 
    //update operation of the input token 
    function swapIn (address tokenIn, address tokenOut, address from, address to,
            uint256 amountIn) internal lockToken(tokenIn) returns(uint256 amountOut)  {
      
          address monoXPoolLocal = address(monoXPool);
      
          amountIn = transferAndCheck(from,monoXPoolLocal,tokenIn,amountIn); 
          
          // uint256 halfFeesInTokenIn = amountIn.mul(fees)/2e5;
      
          uint256 tokenInPrice;
          uint256 tokenOutPrice;
          uint256 tradeVusdValue;
          
          (tokenInPrice, tokenOutPrice, amountOut, tradeVusdValue) = getAmountOut(tokenIn, tokenOut, amountIn);
      
          uint256 oneSideFeesInVusd = tokenInPrice.mul(amountIn.mul(fees)/2e5)/1e18;
      
          // trading in
          if(tokenIn==address(vUSD)){
            vUSD.burn(monoXPoolLocal, amountIn);
            // all fees go to the other side
            oneSideFeesInVusd = oneSideFeesInVusd.mul(2);
          }else{
            //this is the buggy line 
            _updateTokenInfo(tokenIn, tokenInPrice, 0, tradeVusdValue.add(oneSideFeesInVusd), 0);
          }
      
          // trading out
          if(tokenOut==address(vUSD)){
            vUSD.mint(to, amountOut);
          }else{
            if (to != monoXPoolLocal) {
              IMonoXPool(monoXPoolLocal).safeTransferERC20Token(tokenOut, to, amountOut);
            }
            //this is thhe buggy line 
            _updateTokenInfo(tokenOut, tokenOutPrice, tradeVusdValue.add(oneSideFeesInVusd), 0, 
              to == monoXPoolLocal ? amountOut : 0);
          }
      
          emit Swap(to, tokenIn, tokenOut, amountIn, amountOut);
          
        }

  }
  