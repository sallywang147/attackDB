**[Hundred Finance Attack](https://medium.com/immunefi/a-poc-of-the-hundred-finance-heist-4121f23a098)**

[The fix](https://www.radixdlt.com/post/rekt-retweet-11-re-entrancy-why-the-11m-agave-and-hundred-finance-hacks-could-never-happen-on-radix)

According to the link: The exploit boils down to three issues:

1. The Agave contract did not follow the “checks-effects-interactions” pattern, as the borrowed funds were released prior to the debt balance being updated.


2. The re-entrant call from XDAI back to the Hacker’s Contract was only possible because the XDAI contract allowed the “callAfterTransfer” function.


3. And at the root of it all, re-entrancy is mandatory for the EVM to work because tx’s can only call a single smart contract. Functionality across contracts requires developers to string complex chains of calls to one another that sometimes re-enter previous contracts.

It involves two buggy contracts:
ERC677 library contract 
Ctoken.sol from the compound

