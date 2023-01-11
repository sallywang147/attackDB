**[Jay Attack](https://blog.solidityscan.com/jay-token-exploit-reentrancy-attack-d7a4923b6333)**

1. The buyJay() method in the JAY contract supported any ERC-721 token as a parameter.
2. The attacker used the buyJay() method, submitted a fraudulent ERC-721 token, and purchased the corresponding JAY token.
3. The attacker specifically borrowed 72.5 ETH for a flash loan and then spent 22 ETH to purchase the JAY token. The buyJay function was called with another 50.5 ETH with the fake ERC-721 token.
4. During the transfer, the attacker executed and reentered the JAY contract by invoking the sell function on the fake ERC-721 token and sold all JAY tokens. The JAY token price got manipulated since the Ether balance was raised before the buyJay function was initiated.

**deploy link**
use `make attack_vector` and `make deploy-testnet` to reproduce the attack and deploy the buggy contract respectively 
