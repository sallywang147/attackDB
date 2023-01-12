// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.10;

contract contrived{
   function executeWithdrawERC721(
        mapping(address => DataTypes.ReserveData) storage reservesData,
        mapping(uint256 => address) storage reservesList,
        DataTypes.UserConfigurationMap storage userConfig,
        DataTypes.ExecuteWithdrawERC721Params memory params
    ) external returns (uint256) {
        DataTypes.ReserveData storage reserve = reservesData[params.asset];
        DataTypes.ReserveCache memory reserveCache = reserve.cache();

        reserve.updateState(reserveCache);
        uint256 amountToWithdraw = params.tokenIds.length;

        //That burn function will call safeTransferFrom on the tokens provided as collateral, 
        //giving the execution context to the destination address. 
        //This will give us an opportunity to reenter the market, knowing that after reentering the market the configuration that tells the market we have collateral will be set as false
        bool withdrwingAllCollateral = INToken(reserveCache.xTokenAddress).burn(
            msg.sender,
            params.to,
            params.tokenIds,
            reserveCache.nextLiquidityIndex
        );

        ValidationLogic.validateWithdrawERC721(reserveCache);
       //informs the market that the address in question no longer has collateral deposited into the contract
        if (userConfig.isUsingAsCollateral(reserve.id)) {
            if (userConfig.isBorrowingAny()) {
                ValidationLogic.validateHFAndLtv(
                    reservesData,
                    reservesList,
                    userConfig,
                    params.asset,
                    msg.sender,
                    params.reservesCount,
                    params.oracle
                );
            }

            if (withdrwingAllCollateral) {
                userConfig.setUsingAsCollateral(reserve.id, false);
                emit ReserveUsedAsCollateralDisabled(params.asset, msg.sender);
            }
        }

        emit WithdrawERC721(
            params.asset,
            msg.sender,
            params.to,
            params.tokenIds
        );

        return amountToWithdraw;
    }
}