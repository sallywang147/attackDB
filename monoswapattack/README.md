**[MonoX Finance Attack](https://slowmist.medium.com/detailed-analysis-of-the-31-million-monox-protocol-hack-574d8c44a9c8)**

You can deploy the `make deploy-testnet contract_header=Monoswap absolute_path=[path to your contract]`. In our case, the script is `make deploy-testnet contract_header=Monoswap absolute_path=/Users/sallywang/attackreplay/monoswapattack/buggy-contracts/Monoswap.sol`

There're two vulnerabilities in this case:

First, there is no checks performed on `msg.sender` or `to` addresses in removeliquidity() function. Therefore, anyone can remove the 
liquidity in the reserve. The attacker exploited this bug to boost MONO price arbitrarily.

Second, the updatetokeninfo function ignores the corner case when a the same token is passed into TokenIn and TokenOut variables.
Then the attacker repeated the exchange of MONO->MONO, and a total of 55 exchanges were made. he amount of each exchange is the total amount of MONO in the transaction pool minus 1, which is the exchange amount that can maximize the MONO price.

[This article](https://beosin.medium.com/a-full-analysis-of-the-monox-attack-ed41e4a6b254) provides detailed code analysis. 
