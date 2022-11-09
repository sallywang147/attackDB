**[LIFI Attack](https://blocksecteam.medium.com/li-fi-attack-a-cross-chain-bridge-vulnerability-no-its-due-to-unchecked-external-call-c31e7dadf60f)
0. **Connect to Testnet:** run make anvil to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with

1. **Reproduce Attack on Mainnet:** To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

2.**run unit_test:** To run unit test, you can use this command `make unit_test`. 

3. To deploy contracts, go into the folder of healthy-contracts or buggy-contracts. Here is the list of npm scripts you can execute: 


Some of them relies on `./_scripts.js` to allow parameterizing it via command line argument (have a look inside if you need modifications)


`yarn prepare`

As a standard lifecycle npm script, it is executed automatically upon install. It generate config file and typechain to get you started with type safe contract interactions


yarn lint, yarn lint:fix, yarn format and yarn format:fix

These will lint and format check your code. the :fix version will modifiy the files to match the requirement specified in .eslintrc and .prettierrc.


`yarn compile`

These will compile your contracts


`yarn void:deploy`

This will deploy your contracts on the in-memory hardhat network and exit, leaving no trace. quick way to ensure deployments work as intended without consequences


`yarn test [mocha args...]`

These will execute your tests using mocha. you can pass extra arguments to mocha


`yarn coverage`

These will produce a coverage report in the coverage/ folder


`yarn gas`

These will produce a gas report for function used in the tests


`yarn dev`

These will run a local hardhat network on localhost:8545 and deploy your contracts on it. Plus it will watch for any changes and redeploy them.


`yarn local:dev`

This assumes a local node it running on localhost:8545. It will deploy your contracts on it. Plus it will watch for any changes and redeploy them.


**What's the fix of the bug?**

The buggy contract is in ~/contracts/src/Facets/CBridgeFacet.sol. Our contrived.sol has comments regarding the buggy line and why thaat's a bug

Here's the attack flow (multiple function invocations): 

1. `process()` function: a message sender can send tokens to a receiver contract with trusted/verified message. The exploiter
is able to manipulate the receiver contract address to his/her own by passing in fradulent message

2. How does fraulent message pass the check?? because  `process(_msg)` invokes `acceptableRoot(ConfirmedAt(msgCheck(_msg)))`, which further invokes `ConfirmedAt(_root)`
in the initializer. ConfirmedAt(_root) = 1 whenever root = 0

3. when _msg is fradulent, msgCheck(_msg) returns Null. This means _root = msgCheck(_msg) = Null = 0. Hence,ConfirmedAt(msgCheck(_msg)) = 1. The fraddulent message is always greenlighted!

4. fradulent message passes the `acceptableRoot()` check and the execution continues until  `process()` sends tokens to attacker designated address 

To fix the bug, they added a check in the initializer: `if (_committedRoot != bytes32(0)) confirmAt[_committedRoot] = 1;`
