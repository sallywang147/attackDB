**[PolyNetwork Attack](https://research.kudelskisecurity.com/2021/08/12/the-poly-network-hack-explained/)**

Before you run the scripts below, you need to make sure you're in the correct attack directory

0. run make anvil to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with

1. To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

2. deploy the relevant buggy contracts: in the case of PolyNetwork Attack, There are two vulberable contracts - EthCrossChainManager and EthCrossChainData. 

   2a) To deploy buggy EthCrossChainManager, run ``make deploy-buggy-crossChainManager absolute_path=[your-full-path-to-poly-attack]/buggy-contracts/contracts/core/cross_chain_manager/ogic/EthCrossChainManager.sol`.In our case, `make deploy-buggy-crossChainManager absolute_path=/Users/sallywang/attackreplay/polyattack/buggy-contracts/contracts/core/cross_chain_manager/logic/EthCrossChainManager.sol`
   
   2b)To deploy buggy EthCrossChainData, run `make deploy-buggy-crossChainData absolute_path=[your-full-path-to-poly-attack]/buggy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol`. In our case, the command is `make deploy-buggy-crossChainData absolute_path=/Users/sallywang/attackreplay/polyattack/buggy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol` If the contract is sucessfully deployed, you will see deployment information like below: 
  
  ```
  Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  Deployed to: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  Transaction hash: 0x210d0acde91b555d034699bbd7d3a7d0e7a6b002b7527406c459383e0f071522
  ```

3. To deploy the healthy counter-parts, the procedure is very similar and we won't belabor the point here. 

  3a) To deploy healthy EthCrossChainManager, run `make deploy-healthy-crossChainManager absolute_path=/Users/sallywang/attackreplay/polyattack/healthy-contracts/contracts/core/cross_chain_manager/logic/EthCrossChainManagerForUpgrade.sol`. Please note that the correct contract name is a little different from the buggy version
  
  3b) To deploy healthy EthCrossChainData, we deploy-healthy-crossChainData absolute_path=/Users/sallywang/attackreplay/polyattack/healthy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol`. Similar to above, you just need to replace with the correct path. 
  

4. To deploy contrived buggy contracts, run  `make deploy-contrived`


6. Once a contract is deployed, you can interactive with the contract using `cast` command. For example, 

```
cast send --private-key YOUR_PRIVATE_KEY \
--rpc-url RPC-API-ENDPOINT-HERE \
--chain 1284 \
YOUR_CONTRACT_ADDRESS \
"transfer(address,uint256)" 0x0000000000000000000000000000000000000001 1
```
If you want more info on how to interact with deployed contracts, please feel free to checkout this [tutorial](https://docs.moonbeam.network/builders/build/eth-api/dev-env/foundry/) 

**What's the fix of the bug?**

In our contrived.sol, we have explanation on specific line causing the bug. Below are some overview. 
In developer fixed contracts (EthCrossChainManagerForUpgrade.sol), the following function (causing the original bug) is deprecated and inovaction will be automatically reverted: 

The buggy function: 

```
 function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
        // Load Ethereum cross chain data contract
        IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
        
        // To help differentiate two txs, the ethTxHashIndex is increasing automatically
        uint256 txHashIndex = eccd.getEthTxHashIndex();
        
        // Convert the uint256 into bytes
        bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
        
        // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
        bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
            ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
            ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
            ZeroCopySink.WriteUint64(toChainId),
            ZeroCopySink.WriteVarBytes(toContract),
            ZeroCopySink.WriteVarBytes(method),
            ZeroCopySink.WriteVarBytes(txData)
        );
      ```
      
The fixed function: 
      
        ```   
        function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
        revert("Polynetwork v1.0 has been suspended, try v2.0.");
        return true;
    }
         ```
         
