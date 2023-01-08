**[ElasticSwap Attack](https://quillaudits.medium.com/decoding-elastic-swaps-850k-exploit-quillaudits-9ceb7fcd8d1a)**

The root cause is the two different token accounting mechanisms used in `addLiquidity` and `removeLiquidity` functions. For `addLiquidity`,
it uses internal k algorithm; for `removeLiquidity`, it uses the exchange between baseToken and quoteToken in the current pool;

The attackers take four steps: 
1. The attacker begins by adding liquidity to the TIC-USDC pool.
2. then deposits $USDC.e directly into the TIC-USDC pool.
3. The attacker then removed the liquidity, causing the contract’s internal USDC reserve to become unbalanced
4. Finally, when the pool became unbalanced, the attacker swapped USDC for TIC tokens and made a profit out of it

**Deploy**
Update hardhat.config.json with needed credentials
npx hardhat deploy --network goerli --export-all ./artifacts/deployments.json
Verify on etherscan npx hardhat --network goerli etherscan-verify --api-key <APIKEY>
