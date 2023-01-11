**[Fortress Loan Attack](https://www.certik.com/resources/blog/k6eZOpnK5Kdde7RfHBZgw-fortress-loans-exploit)**

The root cause is the submit() function in Chain.sol, where everyone can update the price of a token. 

**Deploy Link**

make deploy-testnet contract_header=Chain absolute_path="absolute path to where you store the contract" args="args your provide to the constructor"
