# [Overview](https://github.com/sallywang147/attackDB/edit/webpage)

This benchmark contains 120 known recent(2020-2023) smart contract bugs and their real contract source code (over 500 smart contracts), including the newest cross-bridge bugs, such as PolyNetwork, and flashloan attacks, such as DODO V2. We also use [Foundry](https://github.com/foundry-rs/foundry) to reproduce each bug in the forked network environment. 

## [Smart Contract Vulnerablility Benchmark](https://github.com/sallywang147/attackDB) | [Vulnerability Detection Tool SymbolicX](https://github.com/sallywang147/symbolicX)

Our benchmark tool is a new realistic evaluation tool covering production-level contracts and is an effort to improve simplified classical bugs covered by [SWC registry](https://github.com/SmartContractSecurity/SWC-registry) and [DeFiVulnLabs](https://github.com/SunWeb3Sec/DeFiVulnLabs) - thanks and credit to SWC and DeFiVulnLab! However, SWC registry does not provide production-level contract source code or bugs exploited in reality. DeFiVulnLabs provide some reproduced bugs, but not contract source code or root cause analysis. Many bugs discovered in prior work are obsolete/only legacy bugs due to new solidity compilers and fast-changing solidity semantics. The lack of more recent smart contract bugs and the lack of realistic production-level buggy contracts in the prior databases pose challenges to web3 researchers in the benchmark domain. Thus we have made siginficant effort in this new benchmark tool to improve and provide new benchmark functionalities.  The IDs of bugs in this benchmark are numbered in roughly chronological order - new bugs with low-numbered IDs. Our innovation and effort in this benchmark tool are:
- 1) **production-level buggy and fixed contracts:** while the other tools provide only the code snippets of simplified vulnerable portion, we have curated the in-production contract source code under deployment, including the original buggy version and developer fixed version; 
- 2) **bug analysis and reproducibility:** we provide detailed analysis and reproduce bugs from real contract source code. In our analysis, we also include instructions on how to reproduce each bug and how to deploy contracts; 
- 3) **deployment of buggy and fixed contracts:** we provide deployment links to deploy the origignal buggy contract source code and fixed contract source code on testnet; 
- 4) **newest bugs (2021-2023) covered:** we expand to the newest bugs that are not covered by other existing tools;
- 5) **annotated buggy snippets:** We provide annotated buggy code snippets of each attack for more efficient evaluation.

To the best of our knowledge, this is the only benchmark tool that incorporates the production-level contract source code under deployment, not just simplified buggy code snippets, and incorporates most recent cross-bridge and flashloan bugs. Building this benchmark, we hope to provide smart contract security researchers with a benchmark tool that's realistic and as close to production-level vulnerability as possible. 

<details><summary> Cross-Bridge Bugs </summary>
<p>

Cross-Bridge Bugs

|ID  | Attacks       |loss($m)|buggy contracts | developer fixed contracts |annotated bug snippets  |reproduced bugs |  analysis|
|--- | ------------- |------- | ---------------- |-------------------|-------------------------| ---|---|
|001 | PolyNetwork   |   610  | [buggy source](https://github.com/polynetwork/eth-contracts/tree/c9212e4199432b0ea6e0defff390e804afe07a32)  | [developer fix](https://github.com/polynetwork/eth-contracts/tree/d491578ef9e49468e7e8d6011014040857ee5d77)     | [contrivedbug1.sol](https://github.com/sallywang147/attackDB/blob/main/polyattack/contrived.sol)                     |[bug vector1](https://github.com/sallywang147/attackDB/blob/main/polyattack/attack_vector.sol)|[Polynetwork Attack](https://github.com/sallywang147/attackDB/tree/main/polyattack)|
|002 | Qubit bridge  |   80   | [buggy source](https://github.com/ChainSafe/chainbridge-solidity/tree/cbfaf9c5d74486447e80a587acc2cd4457002ab3)               | [developer fix](https://github.com/ChainSafe/chainbridge-solidity/tree/2f29dd714a09f075bf6454518a1e57a6e5d55018)               | [contrivedbug2.sol](https://github.com/sallywang147/attackDB/blob/main/qbridgeattack/contrived.sol)                     | [bug vector2](https://github.com/sallywang147/attackDB/blob/main/qbridgeattack/attack_vector.sol) |[Qbridge Attack](https://github.com/sallywang147/attackDB/tree/main/qbridgeattack) |
|003 | Nomad Bridge  |   190  | [buggy source](https://github.com/nomad-xyz/monorepo/tree/6c6e965bec0ef1c1f4197d0510ecdc7e7a552386)               | [developer fix](  https://github.com/nomad-xyz/monorepo/tree/9876327bdf3b938fe9f331bf3ed4179790bf265c)             | [contrivedbug3.sol](https://github.com/sallywang147/attackDB/blob/main/nomadattack/contrived_bug.sol)                     | [bug vector3](https://github.com/sallywang147/attackDB/blob/main/nomadattack/attack_vector.sol) |[Nomad Bridge Attack](https://github.com/sallywang147/attackDB/tree/main/nomadattack) |
|004 | Meter.io      |   4.4  | [buggy source](https://github.com/Uniswap/v2-periphery/tree/0335e8f7e1bd1e8d8329fd300aea2ef2f36dd19f)               | [developer fix](https://github.com/Uniswap/v3-periphery/tree/6cce88e63e176af1ddb6cc56e029110289622317)               | [contrivedbug4.sol](https://github.com/sallywang147/attackDB/tree/main/meterattack)                     | [bug vector4](https://github.com/sallywang147/attackDB/blob/main/meterattack/attack_vector.sol) |[Meter Attack](https://github.com/sallywang147/attackDB/tree/main/meterattack) |
|005 | LIFI          |   600  |[buggy source](https://github.com/lifinance/contracts/tree/36f87e3999fdc0602ee5e959850553db4938fc08)               | [developer fix](https://github.com/lifinance/contracts/tree/aaf7af5f02bad2cc1f307b04444ef1e8d69621e6)               | [contrivedbug5.sol](https://github.com/sallywang147/attackDB/blob/main/lifiattack/contrived.sol)                     | [bug vector5](https://github.com/sallywang147/attackDB/blob/main/lifiattack/attack_vector.sol) |[LIFI Attack](https://github.com/sallywang147/attackDB/tree/main/lifiattack) |
|006 | ChainSwap 1   |   0.5  |[buggy source](https://github.com/sallywang147/attackDB/blob/main/chainswapAttack/bug.sol)              | [developer fix](https://github.com/makevoid/chainswap-contracts/tree/8678d78199b944a97ac5501fb95ba6f34a1cfcee)                | [contrivedbug6.sol](https://github.com/sallywang147/attackDB/blob/main/chainswapAttack/bug.sol)                    | [bug vector6](https://github.com/sallywang147/attackDB/blob/main/chainswapAttack/attack_vector.sol) |[ChainSwap Attack 1](https://github.com/sallywang147/attackDB/tree/main/chainswapAttack) |
|007 | ChainSwap 2   |   8    | see above              |  see above               |  see above      | [bug vector7](https://github.com/sallywang147/attackDB/blob/main/chainswapAttack2/swap-attack.sol) |[ChainSwap Attack 2](https://github.com/sallywang147/attackDB/tree/main/chainswapAttack2) |
|008 | AnySwap  |   1.4   | [buggy source](https://github.com/sallywang147/attackDB/blob/main/anyswapattack/buggy-contracts/anyswapv4.sol)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/anyswapattack/healthy-contracts)               | [contrivedbug8.sol](https://github.com/sallywang147/attackDB/blob/main/anyswapattack/contrivedbug.sol)                     | [bug vector8](https://github.com/sallywang147/attackDB/blob/main/anyswapattack/attack_vector.sol) |[AnySwap Attack](https://github.com/sallywang147/attackDB/tree/main/anyswapattack)|
</p>
</details>

<details><summary> Flashloan Bugs - Oracle and Price Manipulations </summary>
<p>

Flashloan Bugs - Oracle and Price Manipulations

|ID  | Attacks       |loss($m)|buggy contracts | developer fixed contracts |annotated bug snippets  |reproduced bugs |  analysis|
|--- | ------------- |------- | ---------------- |-------------------|-------------------------| ---|---|
|009 | MonoX  |   30   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/monoswapattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/monoswapattack/healthy-contracts)               | [contrivedbug09.sol](https://github.com/sallywang147/attackDB/blob/main/monoswapattack/contrivedbug.sol)                     | [bug vector09](https://github.com/sallywang147/attackDB/blob/main/monoswapattack/attack_vector.sol) |[MonoX Finance Attack](https://github.com/sallywang147/attackDB/tree/main/monoswapattack) |
|010 | Cream Finance  |   130   | [buggy source](https://github.com/CreamFi/compound-protocol/tree/73939e7b6bf3a36fb9b39d41e259a97dc416e2a4)              | [developer fix](https://github.com/CreamFi/compound-protocol)               | [contrivedbug10.sol](https://github.com/sallywang147/attackDB/tree/main/creamfiattack/contrivedbug)                     | [bug vector10](https://github.com/sallywang147/attackDB/blob/main/creamfiattack/attack_vector.sol) |[Cream Finance Attack](https://github.com/sallywang147/attackDB/tree/main/creamfiattack) |
|011 | ElasticSwap  |   0.85   | [buggy source](https://github.com/ElasticSwap/elasticswap/tree/b9bf4b926d5b588e3347c38718b0780e88a57f47)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/elasticswsapattack/healthy-contracts)               | [contrivedbug11.sol](https://github.com/sallywang147/attackDB/blob/main/elasticswsapattack/contrivedbug.sol)                     | [bug vector11](https://github.com/sallywang147/attackDB/blob/main/elasticswsapattack/attack_vector.sol) |[ElasticSwap Attack](https://github.com/sallywang147/attackDB/new/main/elasticswsapattack) |
|012 | BGLD  |   0.18   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/bgldattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/bgldattack/healthy-contracts)               | NA                     | [bug vector12](https://github.com/sallywang147/attackDB/blob/main/bgldattack/attack_vector.sol) |[BGLD Attack](https://github.com/sallywang147/attackDB/tree/main/bgldattack) |
|013 | UEarnPool  |  0.24  | [buggy source](https://github.com/sallywang147/attackDB/tree/main/uearnpoolattack/buggy-contracts)               | NA             | [contrivedbug13.sol](https://github.com/sallywang147/attackDB/blob/main/uearnpoolattack/contrived.sol)                     | [bug vector13](https://github.com/sallywang147/attackDB/blob/main/uearnpoolattack/attack_vector.sol) |[UEarnPool Attack](https://github.com/sallywang147/attackDB/new/main/uearnpoolattack) |
|014 | NXUSD  |   0.5   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/nxattack/buggy-contracts)               | [developer fix](https://github.com/orbs-network/twap/tree/de53971be7fcac03d28440ac24dd4d486754e11c)               | [contrivedbug14.sol](https://github.com/sallywang147/attackDB/blob/main/nxattack/contrived.sol)    | [bug vector14](https://github.com/sallywang147/attackDB/blob/main/nxattack/attack_vector.sol) |[NXUSD Attack](https://github.com/sallywang147/attackDB/new/main/nxattack) |
|015 | ZoomPro Finance(similar to bug16: New Free Dao)  |   0.65   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/zoomfiattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/zoomfiattack/healthy-contracts)               | [contrivedbug15.sol](https://github.com/sallywang147/attackDB/blob/main/zoomfiattack/contrived.sol)                     | [bug vector15](https://github.com/sallywang147/attackDB/blob/main/zoomfiattack/attack_vector.sol) |[ZoomPro Finance Attack](https://github.com/sallywang147/attackDB/tree/main/zoomfiattack) |
|016 | New Free Dao(similar to bug15)  |   150   | NA           | NA             | [contrivedbug16.sol](https://github.com/sallywang147/attackDB/blob/main/freedaoattack/contrived.sol)  | [bug vector16](https://github.com/sallywang147/attackDB/blob/main/freedaoattack/attack_vector.sol) |[New Free Dao Attack](https://github.com/sallywang147/attackDB/tree/main/freedaoattack) |
|017 |  Inverse Finance  |  7   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/inversefiattack/buggy-contracts)               | NA               | [contrivedbug17.sol](https://github.com/sallywang147/attackDB/blob/main/inversefiattack/contrived.vy)    | [bug vector17](https://github.com/sallywang147/attackDB/blob/main/inversefiattack/attack_vector.sol) |[Inverse Finance Attack](https://github.com/sallywang147/attackDB/tree/main/inversefiattack) |
|018 | Fortress Loan |   3  | [buggy source](https://github.com/sallywang147/attackDB/tree/main/fortressattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/fortressattack/healthy-contracts)               | [contrivedbug18.sol](https://github.com/sallywang147/attackDB/blob/main/fortressattack/contrived.sol)                     | [bug vector18](https://github.com/sallywang147/attackDB/blob/main/fortressattack/attack_vector.sol) |[Fortress Loan Attack](https://github.com/sallywang147/attackDB/new/main/fortressattack) |
|019 | Saddle Finance  |   10   | [buggy source](https://github.com/saddle-finance/saddle-contract/tree/141a00e7ba0c5e8d51d8018d3c4a170e63c6c7c4)               | [developer fix](https://github.com/saddle-finance/saddle-contract/tree/8d33811817fdfb7a85da79e811fd811a536d36a7)               | [contrivedbug19.sol](https://github.com/sallywang147/attackDB/blob/main/saddleattack/contrived.sol)   | [bug vector19.0](https://github.com/sallywang147/attackDB/blob/main/saddleattack/attackvectors/attack_vector.sol) [bug vector19.1](https://github.com/Hephyrius/Immuni-Saddle-POC/tree/65537104393499b42c190f241e384ec7295168cd) |[Saddle Finance Attack](https://github.com/sallywang147/attackDB/tree/main/saddleattack) |
|020 | PancakeBunny   |   200   | [buggy source](https://github.com/PancakeBunny-finance/Bunny/tree/5951575e0d74afc335259965a2727ff284a3f293)  | [developer fix](https://github.com/PancakeBunny-finance/Bunny/tree/0e3aeaecbc8493668abb4801af0f3c3ad3b9a829)               | [contrivedbug17.sol](https://github.com/sallywang147/attackDB/blob/main/pbattack/contrived.sol)    | [bug vector16](https://github.com/sallywang147/attackDB/blob/main/pbattack/attack_vector.sol) |[PancakeBunny  Attack](https://github.com/sallywang147/attackDB/new/main/pbattack) |
|021 | WaultFinance |   0.5   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/waultattack/buggy-contracts)               | [developer fix](https://github.com/WaultFinance/WAULT)               | [contrivedbug21.sol](https://github.com/sallywang147/attackDB/blob/main/waultattack/contrived.sol)                    | [bug vector21](https://github.com/sallywang147/attackDB/blob/main/waultattack/attack_vector.sol)|[WaultFinance Attack](https://github.com/sallywang147/attackDB/new/main/waultattack) |
|022 | Nimbus Liquidity(similar attacks: INUKO, BXH)   |  0.76 | [buggy source](https://github.com/sallywang147/attackDB/tree/main/nimbusattack)               | NA              | NA                  | [bug vector22](https://github.com/sallywang147/attackDB/blob/main/nimbusattack/attack_vector.sol) |[Nimbus Attack](https://github.com/sallywang147/attackDB/tree/main/nimbusattack) |
|023 | oneRing Finance  |   2   | not public            | NA              | NA                     | [bug vector23](https://github.com/sallywang147/attackDB/blob/main/oneringattack/attack_vector.sol) |[oneRing Finance Attack](https://github.com/sallywang147/attackDB/tree/main/oneringattack) |
|024 | MUBank(similar attacks: AES, BBOX)  |   0.5   | NA               | NA              | NA                    | [bug vector24](https://github.com/sallywang147/attackDB/blob/main/mubankattack/attack_vector.sol) |[MuBank Attack](https://github.com/sallywang147/attackDB/tree/main/mubankattack) |

</p>
</details>

<details><summary> Flashloan Bugs - Reentrancy  </summary>
<p>

Flashloan Bugs - Reentrancy 

|ID  | Attacks       |loss($m)|buggy contracts | developer fixed contracts |annotated bug snippets  |reproduced bugs |  analysis|
|--- | ------------- |------- | ---------------- |-------------------|-------------------------| ---|---|
|025 | Jay  |   0.18   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/jayattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/jayattack/healthy-contracts)               | [contrivedbug25.sol](https://github.com/sallywang147/attackDB/blob/main/jayattack/contrived.sol) | [bug vector25](https://github.com/sallywang147/attackDB/blob/main/jayattack/attack_vector.sol) |[Jay Attack](https://github.com/sallywang147/attackDB/tree/main/jayattack) |
|026 | DFX  |   5   | [buggy source](https://github.com/dfx-finance/protocol-v1-deprecated/tree/5fbeac837e57ded52e25572390a90c189ef363b1)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/dfxattack/healthy-contracts)               | [contrivedbug26.sol](https://github.com/sallywang147/attackDB/blob/main/dfxattack/contrived.sol)   | [bug vector26](https://github.com/sallywang147/attackDB/blob/main/dfxattack/attack_vector.sol) |[DFX Attack](https://github.com/sallywang147/attackDB/new/main/dfxattack) |
|027 | Market  |   0.18   | [buggy source](https://github.com/curvefi/curve-contract/tree/b0bbf77f8f93c9c5f4e415bce9cd71f0cdee960e)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/marketattack/healthy-contracts)               | NA                  | [bug vector27](https://github.com/sallywang147/attackDB/blob/main/marketattack/attack_vector.sol) |[Market Attack](https://github.com/sallywang147/attackDB/new/main/marketattack) |
|028 | Omni  |   1.5   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/omniattack/buggy-contracts)              | [developer fix](https://github.com/aave/aave-v3-core/tree/ecf60cf42b381b6e2332b91e906d262a071ea144)               | [contrivedbug28.sol](https://github.com/sallywang147/attackDB/blob/main/omniattack/contrived.sol)                     | [bug vector28](https://github.com/sallywang147/attackDB/blob/main/omniattack/attack_vector.sol) |[Omni Attack](https://github.com/sallywang147/attackDB/tree/main/omniattack) |
|029 | Fei Protocol  |   80   | [buggy source](https://github.com/fei-protocol/fei-protocol-core/tree/3b4095a69ca8687f46640f8a40df75e0711f2117)               | [developer fix](https://github.com/fei-protocol/fei-protocol-core/tree/be704ad65a84edfafcc09e3e5fa78865f6a1de18)            | [contrivedbug29.sol](https://github.com/sallywang147/attackDB/blob/main/feiattack/contrived.sol)                     | [bug vector29](https://github.com/sallywang147/attackDB/blob/main/feiattack/attack_vector.sol) |[Fei Protocol Attack](https://github.com/sallywang147/attackDB/tree/main/feiattack) |
|030 | Beanstalk  |   182   | [buggy source](https://github.com/BeanstalkFarms/Beanstalk/tree/7dd0f77e44fe157f294e363bc4b69d8cb1c9f6bb)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/beanstalkattack/healthy-contracts)              | [contrivedbug30.sol](https://github.com/sallywang147/attackDB/blob/main/beanstalkattack/contrived.sol)                    | [bug vector30](https://github.com/sallywang147/attackDB/blob/main/beanstalkattack/attack_vector.sol) |[Beanstalk Attack](https://github.com/sallywang147/attackDB/blob/main/beanstalkattack/attack_vector.sol) |
|031 | n00dleSwap  |   0.29   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/noodleattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/noodleattack/healthy-contracts)               | [contrivedbug31.sol](https://github.com/sallywang147/attackDB/blob/main/noodleattack/contrived.sol)                     | [bug vector31](https://github.com/sallywang147/attackDB/blob/main/noodleattack/attack_vector.sol) |[n00dleSwap Attack](https://github.com/sallywang147/attackDB/tree/main/noodleattack) |
|032 | Revest Finance  |   11.2   | [buggy source](https://github.com/Revest-Finance/RevestContracts/tree/2cab8107b9f570bcfae93df3b928bb5fef3797ef)               | [developer fix](https://github.com/Revest-Finance/RevestContracts/tree/59b533221f62a9a422a2443f2c34060b4c3fd3d1)               | [contrivedbug32.sol](https://github.com/sallywang147/attackDB/blob/main/revestattack/contrived.sol)   | [bug vector32](https://github.com/sallywang147/attackDB/blob/main/revestattack/attack_vector.sol) |[Revest Finance Attack](https://github.com/sallywang147/attackDB/tree/main/revestattack) |
|033 | Hundred Finance  |   11   | [buggy source1-ERC677](https://github.com/smartcontractkit/LinkToken/tree/8fd6d624d981e39e6e3f55a72732deb9f2f832d9) [buggy source2-Ctoken](https://github.com/compound-finance/compound-protocol/blob/compound/2.31-rc0/contracts/CToken.sol)  | [developer fix](https://github.com/sallywang147/attackDB/tree/main/hundredattack/healthy-contracts)              | [contrivedbug33.sol](https://github.com/sallywang147/attackDB/blob/main/hundredattack/contrived.sol)  | [bug vector33](https://github.com/sallywang147/attackDB/blob/main/hundredattack/attack_vector.sol) |[Hundred Finance Attack](https://github.com/sallywang147/attackDB/blob/main/hundredattack/README.md) |
|034 | Paraluni  |   1.7   | [buggy source](https://github.com/paraluni/para-contract/tree/1c2737558198e55662b98340a437608f4f0c8ac6)      | TBA      | [contrivedbug34.sol](https://github.com/sallywang147/attackDB/blob/main/paraluniattack/contrived.sol)                     | [bug vector34](https://github.com/sallywang147/attackDB/blob/main/paraluniattack/attack_vector.sol) |[Paraluni Attack](https://github.com/sallywang147/attackDB/blob/main/paraluniattack/README.md) |
|035 | Bacon Protocol  |   1   | destructed    |  destructed             | NA                    | [bug vector35](https://github.com/sallywang147/attackDB/blob/main/baconattack/attack_vector.sol) |Bacon Attack](https://github.com/sallywang147/attackDB/tree/main/baconattack) |
|036 | Visor Finance  |   8.2   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/visorattack/buggy-contracts)               | [developer fix](https://github.com/VisorFinance/hypervisor/tree/01d896d79ef8c0498d3b3cdfe2abc64c66555fb4)               | [contrivedbug36.sol](https://github.com/sallywang147/attackDB/blob/main/visorattack/contrived.sol)   | [bug vector36](https://github.com/sallywang147/attackDB/blob/main/visorattack/attack_vector.sol) |[Visor Attack](https://github.com/sallywang147/attackDB/tree/main/visorattack) |
|037 | Grim Finance  |   30   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/grimattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/grimattack/healthy-contracts)               | [contrivedbug37.sol](https://github.com/sallywang147/attackDB/blob/main/grimattack/contrived.sol)  | [bug vector37](https://github.com/sallywang147/attackDB/blob/main/grimattack/attack_vector.sol) | [Grim finance Attack](https://github.com/sallywang147/attackDB/tree/main/grimattack) |
|038 | XSurge  |   31  | [buggy source](https://github.com/sallywang147/attackDB/tree/main/xsurgeattack/buggy-contracts)               | [developer fix](https://github.com/sallywang147/attackDB/tree/main/xsurgeattack/healthy-contract)              | [contrivedbug38.sol](https://github.com/sallywang147/attackDB/blob/main/xsurgeattack/contrived.sol)                  | [bug vector38](https://github.com/sallywang147/attackDB/blob/main/xsurgeattack/attack_vector.sol) |[XSurge Attack](https://github.com/sallywang147/attackDB/tree/main/xsurgeattack) |
|039 | Rari Capital  |   80   | [buggy source](https://github.com/sallywang147/attackDB/tree/main/rariattack/buggy-contracts)              | [developer fix](https://github.com/sallywang147/attackDB/tree/main/rariattack/healthy-contracts)               | [contrivedbug39.sol](https://github.com/sallywang147/attackDB/blob/main/rariattack/contrived.sol)                     | [bug vector39](https://github.com/sallywang147/attackDB/blob/main/rariattack/attack_vector.sol) |[Rari Capital Attack](https://github.com/sallywang147/attackDB/tree/main/rariattack) |
|040 | Value Defi  |   7.4   | [buggy source](https://github.com/valuedefi/vaults/tree/dba5c437e721c11d51844f67f46dffd1dcdcbb57)              | [developer fix](https://github.com/valuedefi/vaults/tree/dba5c437e721c11d51844f67f46dffd1dcdcbb57)            | TBA                 | [bug vector40](https://github.com/sallywang147/attackDB/blob/main/valueattack/attack_vector.sol) |[Value Defi Attack](https://github.com/sallywang147/attackDB/tree/main/valueattack) |
|041 | DODO Finance  |   3.8   | [buggy source](https://github.com/DODOEX/dodo-smart-contract/tree/master/contracts)               | [developer fix](https://github.com/DODOEX/contractV2)               | [contrivedbug41.sol](https://github.com/sallywang147/attackDB/blob/main/dodoattack/contrived.sol)             | [bug vector41](https://github.com/sallywang147/attackDB/blob/main/dodoattack/attack_vector.sol) |[DODO Finance Attack](https://github.com/sallywang147/attackDB/tree/main/dodoattack) |
|042 | Harvest Finance  |   34  | [buggy source](https://github.com/harvest-finance/harvest/tree/c3376f9a0a86ca67e1c891ffe451b70f2f4d970d)               | [developer fix](https://github.com/harvest-finance/harvest/tree/master)              | [contrivedbug42.sol](https://github.com/sallywang147/attackDB/blob/main/harvestattack/contrived.sol)   | [bug vector42](https://github.com/sallywang147/attackDB/blob/main/harvestattack/attack_vector.sol) |[Harvest Finance Attack](https://github.com/sallywang147/attackDB/blob/main/harvestattack/README.md) |
|043 | MidasCapital  |  0.65  | TBA   | TBA   | TBA                    | [bug vector43](https://github.com/sallywang147/attackDB/blob/main/midasattack/attack_vector.sol) |[MidasCapital Attack](https://github.com/sallywang147/attackDB/tree/main/midasattack) |
|04x | XXX  |   XX   | [buggy source]()               | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector4x]() |[XX Attack]() |
|04x | XXX  |   XX   | [buggy source]()              | [developer fix]()              | [contrivedbug4x.sol]()                     | [bug vector4x]() |[XX Attack]() |
|04x | XXX  |   XX   | [buggy source]()             | [developer fix]()               | [contrivedbug4x.sol]()                  | [bug vector4x]() |[XX Attack]() |
|04x | XXX  |   XX   | [buggy source]()              | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector4x] |[XX Attack] |
|04x | XXX  |   XX   | [buggy source]()               | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector4x] |[XX Attack] |
|05x | XXX  |   XX   | [buggy source]()               | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector5x]() |[XX Attack]() |

</p>
</details>

<details><summary> Improper Access Control </summary>
<p>

Improper Access Control 

|ID  | Attacks       |loss($m)|buggy contracts | developer fixed contracts |annotated bug snippets  |reproduced bugs |  analysis|
|--- | ------------- |------- | ---------------- |-------------------|-------------------------| ---|---|
|03x | SushiSwap Miso  |   3   | [buggy source]               | [developer fix]               | [contrivedbug9.0.sol][contrivedbug9.1.sol] [contrivedbug9.2.sol] [contrivedbug9.3.sol]                      | [bug vector9] |[xxx Attack] |
|05x | XXX  |   XX   | [buggy source]()               | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector5x]() |[XX Attack]() |
|05x | XXX  |   XX   | [buggy source]()               | [developer fix]()               | [contrivedbug4x.sol]()                     | [bug vector5x]() |[XX Attack]() |

</p>
</details>

<details><summary> Arithmetic Flaws </summary>
<p>

 Arithmetic Flaws 
 
 </p>
</details>
