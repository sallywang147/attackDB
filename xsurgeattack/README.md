**[XSurge Attack](https://medium.com/@Knownsec_Blockchain_Lab/knownsec-blockchain-lab-comprehensive-analysis-of-xsurge-attacks-c83d238fbc55)**

While the  vulnerable function `sell` has reentrancy guard, it invokes `purchase` function inside `sell` function, but 
`purchase` function doesn't have a reentrancy gaurd. The attacker is able to call  `purchase` during fallback while executing `sell`
function;

The likely reason that `purchase` doesn't have reentrancy guard is that it's an internal function. The developer presumably think that
it's safe from reentrancy 

Note that the developer fix here is actually added by us, it's not an official fix offered by XSurge.

**deloy link**
coming soon 
