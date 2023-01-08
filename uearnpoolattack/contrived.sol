/**
 *Submitted for verification at BscScan.com on 2022-09-17
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

abstract contract AbsPool {

        //this contract allows exploiter to extract rewards vy creating subsequent binding
        //contracts/users. As long as the number of subsequent users do not go above max, 
        //then the exploiter can caim team reward by invoking the function below
        function claimTeamReward(address account) external {
        uint256 level = getUserLevel(account);
        LevelConfig storage levelConfig;
        uint256 pendingReward;
        uint256 levelReward;
        if (level != MAX) {
            for (uint256 i; i <= level;) {
                levelConfig = _levelConfigs[i];
                if (_userInfos[account].levelClaimed[i] == 0) {
                    if (i == 0) {
                        levelReward = levelConfig.teamAmount * levelConfig.rewardRate / _feeDivFactor;
                    } else {
                        levelReward = (levelConfig.teamAmount - _levelConfigs[i - 1].teamAmount) * levelConfig.rewardRate / _feeDivFactor;
                    }
                    pendingReward += levelReward;
                    _userInfos[account].levelClaimed[i] = levelReward;
                }
            unchecked{
                ++i;
            }
            }
        }
        if (pendingReward > 0) {
            IERC20(_tokenAddress).transfer(account, pendingReward);
        }
    }

}