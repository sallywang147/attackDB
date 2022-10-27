In this qbridgeattack folder, you will see three main documents (in addition to some .json dependencies)

1)healthy-contracts folder: the README in the directory explains how to deploy the healthy contracts 


2)buggy-contracts folder: the README in the directory explains how to deploy the buggy contracts 

3)qubit_attack.sol: this is the attack vector which can reproduce the attacking scenario on buggy and healthy contracts
separately. There are two ways you can use the qubit_attack.sol to reproduce the attack: 

    a) replace the addresses we have provided in the qubit_attack.sol to the version you'd like to replace. 
    For example, to reporduce the bugggy contract: 
    //attacked version: 0x20E5E35ba29dC3B540a1aee781D0814D5c77Bce6; 
    address QBridge =  [copy paste attacked version here] 
    //attacked version: 0x17B7163cf1Dbd286E262ddc68b553D899B93f526; 
    address QBridgeHandler =  [copy paste attacked version here] 

    Then you just need to run 'make test'. Depending on your file path, you might need to replace the path in the Makefile with your own path in the directory 

    b) deploy your own healthy and buggy contracts and test it in the attack contract: 
    go to the directories of healthy and buggy contracts, follow the README in that directory to deploy it, copy-paste your own address the attack vector. 