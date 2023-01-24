**[Sandbox Finance Attack](https://slowmist.medium.com/the-vulnerability-behind-the-sandbox-land-migration-2abf68933170)**

the buggy function is `_burn` in ERC721BaseToken.sol, which should be internal, not external 
