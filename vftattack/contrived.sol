/**
 *Submitted for verification at BscScan.com on 2022-10-07
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract contrived{

//he function does not determine how long the user has held the token. The attacker deploys a large number of attack contracts in advance, gets the first $VTF via flashloan, then transfers VTF tokens to the attack contract in turn to claim the holding rewards
        function updateUserBalance(address _user) public {
                if(userBalanceTime[_user] > 0){
                                uint256 canMint = getUserCanMint(_user).add(getUserVipCanMint(_user));
                                if(canMint > 0){
                                        userBalanceTime[_user] = block.timestamp;
                                        _mint(_user, canMint);
                                }
                        }else{
                                userBalanceTime[_user] = block.timestamp;
                        }
    }
       
}