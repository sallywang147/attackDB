**[Umbrella Network Attack](https://medium.com/uno-re/umbrella-network-hacked-700k-lost-97285b69e8c7)**

the bug is in `withdraw` function in overture/contracts/StakingRewards.sol: 
`_totalSupply = _totalSupply - amount`, where amount has integer underflow;

The fix is to use `totalSupply.sub(amount)` from math library; 
