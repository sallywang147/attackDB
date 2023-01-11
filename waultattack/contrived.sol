/**
 *Submitted for verification at BscScan.com on 2021-08-03
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract contrived{

        function stake(uint256 amount) external nonReentrant {
        require(amount <= maxStakeAmount, 'amount too high');
        usdt.safeTransferFrom(msg.sender, address(this), amount);
        if(feePermille > 0) {
            uint256 feeAmount = amount * feePermille / 1000;
            usdt.safeTransfer(treasury, feeAmount);
            amount = amount - feeAmount;
        }
        uint256 wexAmount = amount * wexPermille / 1000;
        usdt.approve(address(wswapRouter), wexAmount);
        wswapRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            wexAmount,
            0,
            swapPath,
            address(this),
            block.timestamp
        );
        wusd.mint(msg.sender, amount);
        
        emit Stake(msg.sender, amount);
    }

}