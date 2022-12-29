# [Overview](https://github.com/sallywang147/attackDB/edit/webpage)

This benchmark contains all known XX existing smart contract bugs and their real contract source code, including the newest cross-bridge bugs, such as PolyNetwork, and flashloan attacks, such as DODO V2. We also use [Foundry](https://github.com/foundry-rs/foundry) to reproduce each bug on the forked mainnet environment. 

## [Smart Contract Vulnerablility Benchmark](https://github.com/sallywang147/attackDB) | [Vulnerability Detection Tool SymbolicX](https://github.com/sallywang147/symbolicX)

Our benchmark tool is a new realistic evaluation tool covering production-level contracts and is an effort to improve simplified classical bugs discovered by [SWC registry](https://github.com/SmartContractSecurity/SWC-registry) and [DeFiVulnLabs](https://github.com/SunWeb3Sec/DeFiVulnLabs) - thanks and credit to SWC and DeFiVulnLab! Many bugs discovered in prior work are obsolete/only legacy bugs due to new solidity compilers and fast-changing solidity semantics. The lack of more recent smart contract bugs and the lack of realistic production-level buggy contracts in the prior databases pose challenges to web3 researchers in the benchmark domain. Thus we have made siginficant effort in this new benchmark tool to improve and provide new benchmark functionalities.  The IDs of bugs in this benchmark are numbered in roughly chronological order - new bugs with low-numbered IDs. Our innovation and effort in this benchmark tool are:
- 1) while the other tools provide only the code snippets of simplified vulnerable portion, we have curated the in-production contract source code under deployment, including the original buggy version and developer fixed version; 
- 2) we provide detailed analysis and reproduce bugs from real contract source code. In our analysis, we also include instructions on how to reproduce each bug and how to deploy contracts; 
- 3) we provide deployment links to deploy the origignal buggy contract source code and fixed contract source code on testnet; 
- 4) we expand to the newest bugs that are not covered by other existing tools. 

To the best of our knowledge, this is the only benchmark tool that incorporates the production-level contract source code under deployment, not just simplified buggy code snippets, and incorporates most recent cross-bridge and flashloan bugs. Building this benchmark, we hope to provide smart contract security researchers with a benchmark tool that's realistic and as close to production-level vulnerability as possible. 


|ID  | Attacks       |loss($m)|buggy contracts | developer fixed contracts |annotated bug snippets  |reproduced bugs |  analysis|
|--- | ------------- |------- | ---------------- |-------------------|-------------------------| ---|---|
|001 | PolyNetwork   |   610  | [buggy source](https://github.com/polynetwork/eth-contracts/tree/c9212e4199432b0ea6e0defff390e804afe07a32)  | [developer fix](https://github.com/polynetwork/eth-contracts/tree/d491578ef9e49468e7e8d6011014040857ee5d77)     | [contrivedbug1.sol](https://github.com/sallywang147/attackDB/blob/main/polyattack/contrived.sol)                     |[bug vector1](https://github.com/sallywang147/attackDB/blob/main/polyattack/attack_vector.sol)|[Polynetwork Attack](https://github.com/sallywang147/attackDB/tree/main/polyattack)|
|002 | Qubit bridge  |   80   | [buggy source](https://github.com/ChainSafe/chainbridge-solidity/tree/cbfaf9c5d74486447e80a587acc2cd4457002ab3)               | [developer fix](https://github.com/ChainSafe/chainbridge-solidity/tree/2f29dd714a09f075bf6454518a1e57a6e5d55018)               | [contrivedbug2.sol](https://github.com/sallywang147/attackDB/blob/main/qbridgeattack/contrived.sol)                     | [bug vector2](https://github.com/sallywang147/attackDB/blob/main/qbridgeattack/attack_vector.sol) |[Qbridge Attack](https://github.com/sallywang147/attackDB/tree/main/qbridgeattack) |
|003 | Nomad Bridge  |   190  | [buggy source]               | [developer fix]               | [contrivedbug3.sol]                     | [bug vector2] |[Qbridge Attack] |
|004 | Meter.io      |   4.4  | [buggy source]               | [developer fix]               | [contrivedbug4.sol]                     | [bug vector2] |[Qbridge Attack] |
|005 | LIFI          |   600  |[buggy source]               | [developer fix]               | [contrivedbug5.sol]                     | [bug vector2] |[Qbridge Attack] |
|006 | ChainSwap 1   |   0.5  |[buggy source]               | [developer fix]               | [contrivedbug6.sol]                     | [bug vector2] |[Qbridge Attack] |
|007 | ChainSwap 2   |   8    | [buggy source]               | [developer fix]               | [contrivedbug7.sol]                     | [bug vector2] |[Qbridge Attack] |
|008 | AnySwap  |   1.4   | [buggy source]               | [developer fix]               | [contrivedbug8.sol]                     | [bug vector8] |[AnySwap Attack] |
|009 | xxx  |   xx   | [buggy source]               | [developer fix]               | [contrivedbug9.sol]                     | [bug vector9] |[xxx Attack] |
|010 | xxx  |   xx   | [buggy source]               | [developer fix]               | [contrivedbug10.sol]                     | [bug vector10] |[xxx Attack] |
|011 | xxx  |   xx   | [buggy source]               | [developer fix]               | [contrivedbug11.sol]                     | [bug vector11] |[xxx Attack] |
|012 | xxx  |   xx   | [buggy source]               | [developer fix]               | [contrivedbug12.sol]                     | [bug vector12] |[xxx Attack] |
