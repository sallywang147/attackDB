**[Inverse Finance Attack](https://halborn.com/explained-the-inverse-finance-hack-june-2022/)**

In this case, the vulnerable code existed in the project’s YVCrvCrypto pool.  The Inverse price oracle estimated the value of its LP token price based on the balance of current assets within the pool.  Since the attacker can manipulate this balance of assets through deposits, swaps, and trades, they can manipulate the value of the LP token.

In this case, the attacker took out a flashloan, deposited collateral into the pool and performed a swap to manipulate the perceived value of that collateral.  This allowed them to take out a much larger loan than they should have been able to.  After a few conversions, they were able to pay off their flashloan and make a tidy profit.

Since the source code is in .vy files, we do not provide deploy links here 
