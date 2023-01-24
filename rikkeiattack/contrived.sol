pragma solidity ^0.5.16;

import "./PriceOracle.sol";
import "./RBep20.sol";

contract contived {
    function setOracleData(address rToken, oracleChainlink _oracle) external {
        oracleData[rToken] = _oracle;
    }
}