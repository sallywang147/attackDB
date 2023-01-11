
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

contract contrived{

// VaultFlipToFlip 0xd415e6caa8af7cc17b7abd872a42d5f2c90838ea
function getReward() external override {
        uint amount = earned(msg.sender); // returns 0.000521785526032378e18
        // ...
    
        amount = _withdrawTokenWithCorrection(amount); // withdraws same amount from MasterChef
        uint depositTimestamp = _depositedAt[msg.sender];
        uint performanceFee = canMint() ? _minter.performanceFee(amount) : 0; // 30% of earned
        if (performanceFee > DUST) {
            // important call that internally mints the BUNNY tokens
            _minter.mintForV2(address(_stakingToken), 0, performanceFee, msg.sender, depositTimestamp);
            amount = amount.sub(performanceFee);
        }
    
        _stakingToken.safeTransfer(msg.sender, amount); // withdraws 70% of earned LP tokens
    }
    
    function balance() public view override returns (uint amount) {
        (amount,) = CAKE_MASTER_CHEF.userInfo(pid, address(this)); // total LP token balance of all depositors
    }
    function balanceOf(address account) public view override returns(uint) {
        if (totalShares == 0) return 0;
        return balance().mul(sharesOf(account)).div(totalShares);
    }
    function earned(address account) public view override returns (uint) {
        if (balanceOf(account) >= principalOf(account) + DUST) {
            return balanceOf(account).sub(principalOf(account));
        } else {
            return 0;
        }
    }

// BunnyMinterV2.sol 0x819eea71d3f93bb604816f1797d4828c90219b5d
function mintForV2(address asset /* LP token */, uint _withdrawalFee /* 0 */, uint _performanceFee /* 0.00015... */, address to /* attacker */, uint) external payable override onlyMinter {
    uint feeSum = _performanceFee.add(_withdrawalFee);
    _transferAsset(asset, feeSum); // transfers LP tokens from VaultFlipToFlip to this

    // removes liquidity from WBNB <> BUSDT pool. Because of previously minted LPs returns
    // 2,961,750 USDT and 7,744 WBNB
    // then swaps these to WBNB and BUNNY using the manipulated v1 pool
    // and provides liquidity to the WBNB <> BUNNY pool returns these LP tokens as bunnyBNBAmount
    uint bunnyBNBAmount = _zapAssetsToBunnyBNB(asset, feeSum, true);

    if (bunnyBNBAmount == 0) return;

    IBEP20(BUNNY_BNB).safeTransfer(BUNNY_POOL, bunnyBNBAmount);
    IStakingRewards(BUNNY_POOL).notifyRewardAmount(bunnyBNBAmount);

    (uint valueInBNB,) = priceCalculator.valueOfAsset(BUNNY_BNB, bunnyBNBAmount); // returns inflated value
    uint contribution = valueInBNB.mul(_performanceFee).div(feeSum);
    uint mintBunny = amountBunnyToMint(contribution); // multiplies by 3 (1 WBNB : 3 BUNNY)
    if (mintBunny == 0) return;
    _mint(mintBunny, to); // mints BUNNY for attacker
}

// PriceCalculatorBSCV1.sol 0x81ef2bc1e02fee5414e46accc6ae14d833eebba0
function valueOfAsset(address asset, uint amount) public view override returns (uint valueInBNB, uint valueInUSD) {
        if (keccak256(abi.encodePacked(IPancakePair(asset).symbol())) == keccak256("Cake-LP")) {
            (uint reserve0, uint reserve1, ) = IPancakePair(asset).getReserves();
            if (IPancakePair(asset).token0() == WBNB) {
                valueInBNB = amount.mul(reserve0).mul(2).div(IPancakePair(asset).totalSupply());
                valueInUSD = valueInBNB.mul(priceOfBNB()).div(1e18);
            } else if (IPancakePair(asset).token1() == WBNB) {
                valueInBNB = amount.mul(reserve1).mul(2).div(IPancakePair(asset).totalSupply());
                valueInUSD = valueInBNB.mul(priceOfBNB()).div(1e18);
            } else {
                // ... recursion on both, not relevant
            }
        }
    }

}