**[Qubit Bridge Attack](https://certik.medium.com/qubit-bridge-collapse-exploited-to-the-tune-of-80-million-a7ab9068e1a0)**

0. **Connect to Testnet:** run make anvil to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with

1. **Reproduce Attack on Mainnet:** To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

**Important for deployment**: since chainsafe-bridge contracts depend on openzeppelin contracts, make sure you run `forge install openzeppelin/openzeppelin-contracts` and update remappings.txt in each buggy-contracts or healthy-contracts folder before running deploy scripts. Check out [here](https://github.com/sambacha/foundry-docs/blob/master/FORGE.md) for specific remappings.txt info 

If you have trouble deploying the contracts with our provided scripts, you can also use the CLI scripts provided by ChainSafe-Bridge [here](https://github.com/ChainSafe/chainbridge-deploy/blob/main/cb-sol-cli/README.md). 

2. **Deploy relevant buggy contracts:** in the case of Qbridg Attack, There are two vulberable contracts - Bridge.sol and ERC20Handler.sol. Due to specific dependencies, we need to deploy the contracts in the folder where the contract resides.

    2a)  To deploy buggy Bridge.sol: 
    
    First, run `cd ~/attackDB/qbridgeattack/buggy-contracts/contracts` 
    
    Second, run `forge create Bridge --contracts  [your-full-path-to-attackDB]/qbridgeattack/buggy-contracts/contracts/Bridge.sol --constructor-args [provide your constructor arguments here]--rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`. If you don't know constructor arguments, you can comment out the constructor function and do an abstract deployment 
    
   2b) To deploy handler the handler contract: 
   
   First, run `cd ~/attackDB/qbridgeattack/buggy-contracts/contracts/handlers`
   
   Second, run `forge create ERC20Handler --contracts [your-full-path-to-attackDB]/qbridgeattack/buggy-contracts/contracts/handlers/ERC20Handler.sol --constructor-args [deployed bridge address from 2a] --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`


If the contract is sucessfully deployed, you will see deployment information like below: 
  
  ```
  Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  Deployed to: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  Transaction hash: 0x210d0acde91b555d034699bbd7d3a7d0e7a6b002b7527406c459383e0f071522
  ```

3. **Deploy relevant healthy contracts:** To deploy the healthy counter-parts, the procedure is very similar and we won't belabor the point here. 

  3a) To deploy healthy Bridge.sol
  
  First, run `cd cd ~/attackDB/qbridgeattack/healthy-contracts/contracts'
  
  Second, run `forge create Bridge --contracts  [your-full-path-to-attackDB]/qbridgeattack/healthy-contracts/contracts/Bridge.sol --constructor-args [provide your constructor arguments here]--rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`. If you don't know constructor arguments, you can comment out the constructor function and do an abstract deployment 
    
  
  3b) To deploy healthy handler contract, 
  
  First, run `cd cd ~/attackDB/qbridgeattack/healthy-contracts/contracts'
  
   Second, run `forge create ERC20Handler --contracts  [your-full-path-to-attackDB]/qbridgeattack/healthy-contracts/contracts/handlers/ERC20Handler.sol --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`. If you don't know constructor arguments, you can comment out the constructor function and do an abstract deployment 
    

4.  **Deploy contrived contracts:**  To deploy contrived buggy contracts, run  `make deploy-contrived`


6. **Interacting with deployed contracts:** Once a contract is deployed, you can interactive with the contract using `cast` command. For example, 

```
cast send --private-key YOUR_PRIVATE_KEY \
--rpc-url RPC-API-ENDPOINT-HERE \
--chain 1284 \
YOUR_CONTRACT_ADDRESS \
"transfer(address,uint256)" 0x0000000000000000000000000000000000000001 1
```
If you want more info on how to interact with deployed contracts, please feel free to checkout this [tutorial](https://docs.moonbeam.network/builders/build/eth-api/dev-env/foundry/) 

**What's the fix of the bug?**

From [this article](https://certik.medium.com/qubit-bridge-collapse-exploited-to-the-tune-of-80-million-a7ab9068e1a0), the root is at deposit() in  ERC20Handler.sol. The fixed code now use lockERC20() function from Openzeppeplin rather than the buggy version, safeTransferFrom(), which was implemented by Qubit Bridge itself 
