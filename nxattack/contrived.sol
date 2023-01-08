// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "../interfaces/IOracle.sol";

contract JLPWAVAXUSDCOracle is IOracle {
    IJoePair constant public joePair = IJoePair(0xf4003F4efBE8691B60249E6afbD307aBE7758adb);
    IAggregator constant public AVAX = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
    IAggregator constant public USDC = IAggregator(0xF096872672F44d6EBA71458D74fe67F9a77a23B9);

    function _get() internal view returns (uint256) {

        uint256 usdcPrice = uint256(USDC.latestAnswer());
        uint256 avaxPrice = uint256(AVAX.latestAnswer());
        (uint112 wavaxReserve, uint112 usdcReserve, ) = joePair.getReserves();

        //this is the buggy line: it computes price by real-time reserve update
        //it ignores time weighted average price mechanism 
        //thus it fails to prevent potential single block manipulation
        uint256 price = (wavaxReserve * avaxPrice + usdcReserve * usdcPrice * 1e12) / uint256(joePair.totalSupply());

        return 1e26 / price;
    }
}