**[UEarnPool Attack](https://twitter.com/CertiKAlert/status/1593094922160128000)** 
[this article](https://learnblockchain.cn/article/5074#1.UEarnPool%E6%BC%8F%E6%B4%9E%E7%AE%80%E4%BB%8B) offers more detailed analysis in Chinese
 
Root Cause: 

1. the attacker first uses flash loan to initiate a transactionn on the vulnerable contract - AbsPool.sol;
2. Then the attacker exploits `claimTeamReward` function by creating binding contracts as subsequent users;
3. The more binding users the attacker creates (within the pre-determined Max level), them more rewards the attacker gets;
4. the attacker maximizes profit by redeeming team rewards on the last binding contract (s)he created;
5. redeem profits and pay back the loan; 

**Deploy Link**

`make deploy-testnet contract_header=AbsPool absolute_path=[path to where your store the buggy contract]`
<img width="1106" alt="Screen Shot 2023-01-08 at 7 42 06 AM" src="https://user-images.githubusercontent.com/60257613/211196582-ffb0ac17-7658-43e3-b370-196081269d24.png">
