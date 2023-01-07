pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

//tx: https://etherscan.io/tx/0x0fe2542079644e107cbf13690eb9c2c65963ccb79089ff96bfaf8dced2331c92

interface ICether {
    function borrow(uint borrowAmount) external returns (uint);
    function mint() external payable;
    function underlying() external view returns(address);
}

interface ICrToken {
    function borrow(uint256 borrowAmount) external;
    function mint(uint256 mintAmount) external;
    function underlying() external view returns(address);
}


interface IComptroller {
    function enterMarkets(address[] memory cTokens) external;
    function getAllMarkets() external view returns(address[] memory markets);
}

contract ContractB {
    IERC20 private constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    address private constant yusd = 0x4B5BfD52124784745c1071dcB244C6688d2533d3;
    address private constant cryusd = 0x4BAa77013ccD6705ab0522853cB0E9d453579Dd4;
    address private constant creth = 0xD06527D5e56A3495252A528C4987003b712860eE;
    address private constant comptroller = 0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258;

    constructor() {
        //tell cream we want to borrow agains eth;
        address[] memory markets = new address[](1);
        markets[0] = creth;
        IComptroller(comptroller).enterMarkets(markets);
    }

    function depositAndBorrow() external payable {
        //deposit our collateral
        ICether(creth).mint{value: msg.value}();
        console.log("creth recieved: %s", IERC20(creth).balanceOf(address(this)));

        //borrow yusd
        uint amount = IERC20(yusd).balanceOf(address(cryusd)) - 1;
        ICrToken(cryusd).borrow(amount);
        IERC20(yusd).transfer(msg.sender, IERC20(yusd).balanceOf(address(this)));
    }
}