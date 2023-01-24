**[Immune Fi Attack](https://medium.com/immunefi/88mph-function-initialization-bug-fix-postmortem-c3a2282894d3)**

The `init` function in [88mph-contracts/contracts/NFT.sol](https://github.com/88mphapp/88mph-contracts/blob/a4c48d61661ae3d8ce5aadfda6e4de27c4f07a9e/contracts/NFT.sol#L39)
misses an onlyOwner modifier, and there was also no initializer modifier to prevent a re-initialization. In other words, the init() function was unprotected and was callable multiple times — and by anyone

The fix is below: 

1. Use a constructor instead of an init() function
2. Add an onlyOwner modifier
3. Add an initializer modifier to make the init() function only callable once
