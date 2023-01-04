**[Nimbus Attack](https://neptunemutual.com/blog/nimbus-platform-flash-loan-attack)**

This attack has less to do with smart contract logic bugs, but oracle price validation. Therefore, we only include the "buggy-contract"
source code and attack vector to reproduce the attack scenario. 

The vulnerable function invoked in the contract is `function getReward() public override nonReentrant updateReward(msg.sender)`. 
This function requires the computation on prices fed on $NIMB and $GNIMB. However,  The price of $NIMB is computed using the manipulated $NIMB minus $NBU_WBNB pair.
The root cause of this attack is that Nimbus replies on only one liquidity pool to determine the exchange rate. The attacker borrowed 75,477 $BNB and swapped it for $NBU_WBNB to withdraw the majority of the $NIMB from the pool.
