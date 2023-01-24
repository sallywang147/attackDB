//SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

contract contrived{
 function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
    require(amount > 0, "Cannot withdraw 0");
    _totalSupply = _totalSupply - amount;
    _balances[msg.sender] = _balances[msg.sender].sub(amount);
    stakingToken.safeTransfer(msg.sender, amount);

    emit Withdrawn(msg.sender, amount);
  }
}