**Smart Contract Vulnerablility Database**

As of Nov. 7, this database contains all 7 known smart-contract based cross bridge attacks and their source code (including both
the buggy version and developer fixed version) so far. The (perhaps overly ambitious) end goal of this database is to curate all existing smart contract bugs, provide root cause analysis, and create a benchmarking and analysis tool for web3 security researchers. 

We build this database based on [foundry](https://github.com/smartcontractkit/foundry-starter-kit)
for attack reproducing and contracts deploying purposes. Below are the scripts for 1) reproducing each attack; 2) deploying 
buggy contracts; 3)deploying developed fixed contracts; 4) unit testing buggy contracts (or contrived buggy contracts). In the case 
of highly sophisticated attacks, we provide contrived buggy contracts to zoom in on the buggy code portion and hopefully 
provide better clarity for users of this database. The database are below: 

| Attacks       |  date    |loss($m)|buggy source code | fixed source code |contrived bug included   |unit test        |
| ------------- | -------- |------- | ---------------- |-------------------|-------------------------|-----------------|
| PolyNetwork   | 8/10/2021|   610  | yes              | yes               | yes                     |no (fuzz tested) |
| Qubit bridge  | 1/27/2022|   80   | yes              | yes               | yes                     | yes             |
| Nomad Bridge  | 8/03/2022|   190  | yes              | yes               | yes                     | yes             |
| Meter.io      | 2/06/2021|   4.4  | yes              | yes               | yes                     | yes             |
| LIFI          | 3/20/2022|   600  | yes              |yes                | yes                     | yes             |
| ChainSwap 1   | 7/10/2021|   0.5  | yes              |yes                | yes                     | yes             |
| ChainSwap 2   | x/xx/2021|   8    | yes              |yes                | yes                     | yes             |

**Set Up**

1. git clone the repo: git clone git@github.com:sallywang147/attackDB.git

2. change into the attackDB directory: `cd ~/attackDB` 

3. when you are in the buggy-contracts and healthy-contracts directories, be sure to initialize submodules linking to contract source code: `git submodule update --init --recursive`. A common deployment error "nothing to compile" is likely due to empty/unitialized submodules

4. Since foundry and openzeppelin contracts are the dependencies of the source code and deploying tools in this database,  you will need to install foundry and openzeppelin first if you haven't done so. Please follow the foundry installation instructions [here](https://book.getfoundry.sh/getting-started/installation) and istall openzeppelin contracts [here](https://docs.openzeppelin.com/cli/2.6/getting-started). If you encounter errors during deployment, it's likely one or both of those dependencies are missing
 
5. To explore each attack individual, cd into the directory of that attack. Take PolyNetwork as an example,  `cd ~/attackDB/polyattack` and then run the scripts provided below

**As a Demo, we'll explain PolyNetwork Attack in detail in the main README page here. To explore other attacks, the README is added inside the directory of each attack**

**[PolyNetwork Attack](https://research.kudelskisecurity.com/2021/08/12/the-poly-network-hack-explained/)**

Before you run the scripts below, you need to make sure you're in the correct attack directory

0. **Connect to Testnet:** run  `make anvil` to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with. This is where you can see your interactive history with deployed contracts: including cast call balance, send ethers, etc. If your connect to anvil succesfully, you should see a pop-up terminal with the following: 


                             _   _
                            (_) | |
      __ _   _ __   __   __  _  | |
     / _` | | '_ \  \ \ / / | | | |
    | (_| | | | | |  \ V /  | | | |
     \__,_| |_| |_|   \_/   |_| |_|

    0.1.0 (870da6f 2022-10-19T00:12:30.399897Z)
    https://github.com/foundry-rs/foundry

Available Accounts
==================

(0) 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 (10000 ETH)
(1) 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 (10000 ETH)
(2) 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc (10000 ETH)
(3) 0x90f79bf6eb2c4f870365e785982e1f101e93b906 (10000 ETH)
(4) 0x15d34aaf54267db7d7c367839aaf71a00a2c6a65 (10000 ETH)
(5) 0x9965507d1a55bcc2695c58ba16fb37d819b0a4dc (10000 ETH)
(6) 0x976ea74026e726554db657fa54763abd0c3a0aa9 (10000 ETH)
(7) 0x14dc79964da2c08b23698b3d3cc7ca32193d9955 (10000 ETH)
(8) 0x23618e81e3f5cdf7f54c3d65f7fbc0abf5b21e8f (10000 ETH)
(9) 0xa0ee7a142d267c1f36714e4a8f75612f20a79720 (10000 ETH)

Private Keys


1. **Reproduce Attack on Mainnet:** To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

2. **Deploy relevant buggy contracts:** in the case of PolyNetwork Attack, There are two vulberable contracts - EthCrossChainManager and EthCrossChainData. 

   2a) To deploy buggy EthCrossChainManager, run `make deploy-buggy-crossChainManager absolute_path=[your-full-path-to-poly-attack]/buggy-contracts/contracts/core/cross_chain_manager/ogic/EthCrossChainManager.sol`.In our case, `make deploy-buggy-crossChainManager absolute_path=/Users/sallywang/attackreplay/polyattack/buggy-contracts/contracts/core/cross_chain_manager/logic/EthCrossChainManager.sol`
   
   2b)To deploy buggy EthCrossChainData, run `make deploy-buggy-crossChainData absolute_path=[your-full-path-to-poly-attack]/buggy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol`. In our case, the command is `make deploy-buggy-crossChainData absolute_path=/Users/sallywang/attackreplay/polyattack/buggy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol` If the contract is sucessfully deployed, you will see deployment information like below: 
  
  ```
  Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  Deployed to: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  Transaction hash: 0x210d0acde91b555d034699bbd7d3a7d0e7a6b002b7527406c459383e0f071522
  ```

3. **Deploy relevant healthy contracts:** To deploy the healthy counter-parts, the procedure is very similar and we won't belabor the point here. 

  3a) To deploy healthy EthCrossChainManager, run `make deploy-healthy-crossChainManager absolute_path=/Users/sallywang/attackreplay/polyattack/healthy-contracts/contracts/core/cross_chain_manager/logic/EthCrossChainManagerForUpgrade.sol`. Please note that the correct contract name is a little different from the buggy version
  
  3b) To deploy healthy EthCrossChainData, we deploy-healthy-crossChainData absolute_path=/Users/sallywang/attackreplay/polyattack/healthy-contracts/contracts/core/cross_chain_manager/data/EthCrossChainData.sol`. Similar to above, you just need to replace with the correct path. 
  

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

**Note: to verify your transaction history with the deployed contract, go to the terminal where you connected with Anvil. It will show your interactions with a specific contract deployed via Anvil-Hardhat** 

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
         
