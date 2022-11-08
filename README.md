**Smart Contract Vulnerablility Database**

As of Nov. 7, this database contains 7 smart-contract based cross bridge attacks and their source code (including both
the buggy version and developer fixed version) so far. We build this database based on [foundry](https://github.com/smartcontractkit/foundry-starter-kit)
for attack reproducing and contracts deploying purposes. Below are the scripts for 1) reproducing each attack; 2) deploying 
buggy contracts; 3)deploying developed fixed contracts; 4) unit testing buggy contracts (or contrived buggy contracts). In the case 
of highly sophisticated attacks, we provide contrived buggy contracts to zoom in on the buggy code portion and hopefully 
provide better clarity for users of this database. The database are below: 

| Attacks       | buggy source code |fixed source code  |contrived contract included|unit test included|
| ------------- | ----------------- | ------------------|---------------------------|------------------|
| PolyNetwork   | Content Cell      | Content Cell |
| Qubit bridge  | Content Cell      | Content Cell |
| Nomad Bridge
| Meter.io
| LIFI
|
**Set Up**

1. git clone the repo: git clone git@github.com:sallywang147/attackDB.git

2. change into the attackDB directory: `cd ~/attackDB` 

3. initialize submodules linking to contract source code: `git submodule update --init --recursive`


