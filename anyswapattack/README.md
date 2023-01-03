[AnySwap Attack Analysis](https://medium.com/zengo/without-permit-multichains-exploit-explained-8417e8c1639b)

This bug is less likely to be caught by fuzzing/symbolic execution, because it invokes the fall-back function in the attacker's own WETH
contract. However, we can still show vulnerability by deploying the vulnerable contract and reproduce attack scenario on testnet.

`address _underlying = AnyswapV1ERC20(token).underlying()`: this is the problematic line unwrap the underlying token (“DAI”) from 
the its anyToken wrapping (“anyDAI”). However, token now is the attacker’s controlled contract. We can see in the debugger,
that this contract now returns WETH as its “underlying asset”. 
Multichain failed here as this function should have checked if the token address is indeed a Multichain token. 

In order to deploy the vulnerable contract, you need to provide constructor arguments. You can use the addresses provided by Anvil. 
The deploy scripts would be `make deploy-testnet contract_header=(_contract name_) absolute_path=(_absolute path to where you store the contract_)
args=(_"address1 address2 address3"_)`

For example, we use the following deploying scripts: `make deploy-testnet contract_header=AnyswapV4Router absolute_path=/Users/sallywang/attackreplay/anyswapattack/buggy-contracts/anyswapv4.sol args="0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 0x70997970c51812dc3a010c7d01b50e0d17dc79c8 0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc"`
If it's successfully deployed, you'll see the following result: 
<img width="936" alt="Screen Shot 2023-01-02 at 10 13 45 PM" src="https://user-images.githubusercontent.com/60257613/210295792-75de9efe-1a63-4ec1-badf-842274776a01.png">

You can interact with deployed contract using `cast` command: 
<img width="1197" alt="Screen Shot 2023-01-02 at 11 30 34 PM" src="https://user-images.githubusercontent.com/60257613/210300307-ef6b71d9-e280-445b-8ce2-fe991f062396.png">

To reprodduce the attack, please run `make attack_vector`.
