/**
 *Submitted for verification at polygonscan.com on 2022-06-05
*/

// File: xvmc-contracts/libs/poolLibraries.sol



pragma solidity 0.6.12;


contract contrived{

// migrateStake function does not check if the input oldStaking is expected. 
//As a result, attackers can forge oldStaking contracts to arbitrarilys add balances
    function migrateStake(address _staker, uint256 _stakeID) public {
        require(migrationPool != address(0), "migration not activated");
        require(_stakeID < userInfo[_staker].length, "invalid stake ID");
        UserInfo storage user = userInfo[_staker][_stakeID];
		require(user.shares > 0, "no balance");
        
        uint256 currentAmount = (balanceOf().mul(user.shares)).div(totalShares);
        totalShares = totalShares.sub(user.shares);
		
        user.shares = 0; // equivalent to deleting the stake. Pools are no longer to be used,
						//setting user shares to 0 is sufficient
		
		IacPool(migrationPool).hopDeposit(currentAmount, _staker, user.lastDepositedTime, user.mandatoryTimeToServe);

        emit MigrateStake(msg.sender, currentAmount, user.shares, _staker);
    }
}