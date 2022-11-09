**[Nomad Bridge Attack](https://www.coinbase.com/blog/nomad-bridge-incident-analysis)**

0. **Connect to Testnet:** run make anvil to connect to anvil testnet, which provides you with starter accounts, private keys,  and ethers to experiment with

1. **Reproduce Attack on Mainnet:** To reproduce polynetwork attack on the mainnet: `make attack_vector`. It will generate stack traces when vulnerable functions are invoked and the corrresponding output as a result of invoking vulnerable functions.

2. **Important for deployment**: since nomad-bridge contracts depend on summa-tx and openzeppelin contracts, Foundry doesn't work as
well when contracts have multiple external dependencies. Therefore, we will provide deploy scripts from Nomad Bridge documentations
[here](https://github.com/nomad-xyz/monorepo/tree/main/packages/deploy). Nomad has provided full scripts and env config. 

If you'd still like to try deploying with Foundry, then the easiest thing would be to change the dependencies in contracts by replacing 
`@[dependent-contracts]` with specific contract paths

3. fuzz test contract is added as NomadFuzz.t.sol


**What's the fix of the bug?**

Here's the attack flow (multiple function invocations): 

1. `process()` function: a message sender can send tokens to a receiver contract with trusted/verified message. The exploiter
is able to manipulate the receiver contract address to his/her own by passing in fradulent message

2. How does fraulent message pass the check?? because  `process(_msg)` invokes `acceptableRoot(ConfirmedAt(msgCheck(_msg)))`, which further invokes `ConfirmedAt(_root)`
in the initializer. ConfirmedAt(_root) = 1 whenever root = 0

3. when _msg is fradulent, msgCheck(_msg) returns Null. This means _root = msgCheck(_msg) = Null = 0. Hence,ConfirmedAt(msgCheck(_msg)) = 1. The fraddulent message is always greenlighted!

4. fradulent message passes the `acceptableRoot()` check and the execution continues until  `process()` sends tokens to attacker designated address 

To fix the bug, they added a check in the initializer: `if (_committedRoot != bytes32(0)) confirmAt[_committedRoot] = 1;`
