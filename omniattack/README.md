**[Omni Attack](https://medium.com/immunefi/hack-analysis-omni-protocol-july-2022-2d35091a0109)**

The executeWithdrawERC721 function is run when a user wants to remove their NFT collateral from the market. Though it’s not included in the above snippet for simplicity, one of the last things the function does is calling userConfig.setUsingAsCollateral(reserve.id, false), which informs the market that the address in question no longer has collateral deposited into the contract. But the NToken.burn gets called before that, as we can see in the snippet. That burn function will call safeTransferFrom on the tokens provided as collateral, giving the execution context to the destination address. This will give us an opportunity to reenter the market, knowing that after reentering the market the configuration that tells the market we have collateral will be set as false.

Note: the buggy sources provided in the link below are not always accurate
 [historical collection of reentrancy attacks](https://github.com/pcaversaccio/reentrancy-attacks)
