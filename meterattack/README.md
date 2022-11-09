**[Meter.io Attack](https://medium.com/@Knownsec_Blockchain_Lab/knownsec-blockchain-lab-meter-io-attack-analysis-38cc5207d4cf)**

0. **Connect to Testnet:** run make anvil to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with

1. **Reproduce Attack on Mainnet:** To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

2.**run unit_test:** To run unit test, you can use this command `make unit_test`. 

3. To deploy contracts, go into the folder of healthy-contracts or buggy-contracts. Here is the list of npm scripts you can execute: 

This attack uses UniSwap contracts so we can deploy them use UniSwap scripts [here](https://github.com/second-state/how_to_deploy_uniswap)


**What's the fix of the bug?**

The bug is in  UniSwap/v2-periphery/contracts/UniswapV2Router01.sol. More analysis will be added shortly
