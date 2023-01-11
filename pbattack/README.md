**[PancakeBunny Attack](https://cmichel.io/bsc-pancake-bunny-exploit-post-mortem/)**

1. The attacker deploys a contract, already acquires 9.2751 WBNB<>BUSD-T PancakeSwap LP tokens (380$), and deposits them to the VaultFlipToFlip contract in this first transaction.
Attacker takes a flashloan

2. Mints 144,445.5921 WBNB<>BUSDT v2 LP tokens to the pair contract itself. (The BunnyMinter will later receive these LP tokens when it calls the router.removeLiquidity function.)

3. Swaps 2,315,631 WBNB to 3,826,047 BUSDT in the different lower liquidity PancakeSwap v1 USDT/BNB pool, significantly increasing the WBNB in the pool’s reserves.

4. Attacker withdraws the “profit” of the staked LP tokens from 1) by calling VaultFlipToFlip.getReward() plus 6,972,455 minted BUNNY tokens. The minting of large amounts of BUNNY tokens on the performance fee is due to a wrong LP price calculation.

5. Trades the BUNNY tokens to WBNB.

6. Repays all flashloans.

**deploy link**
According to pancakeSwap website, all contracts are deployed here https://docs.pancakeswap.finance/code/smart-contracts/pancakeswap-exchange/v2/router-v2
To reproduce attack, run `make attack_vector`
