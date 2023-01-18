// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity 0.6.12;

import "./ParaToken.sol";
import "./interfaces/IERC20.sol";
import "./libraries/SafeERC20.sol";
import "./libraries/EnumerableSet.sol";
import "./libraries/SafeMath_para.sol";
import "./interfaces/IWETH.sol";
import './interfaces/IParaRouter02.sol';
import './interfaces/IParaPair.sol';
import './libraries/TransferHelper.sol';
import './interfaces/IFeeDistributor.sol';
import './ParaProxy.sol';

interface IParaTicket {
    function level() external pure returns (uint256);
    function tokensOfOwner(address owner) external view returns (uint256[] memory);
    function setApprovalForAll(address to, bool approved) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function setUsed(uint256 tokenId) external;
    function _used(uint256 tokenId) external view returns(bool);
}

interface IMigratorChef {
    function migrate(IERC20 token) external returns (IERC20);
}

contract MasterChef is ParaProxyAdminStorage {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of T42s
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accT42PerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accT42PerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. T42s to distribute per block.
        uint256 lastRewardBlock; // Last block number that T42s distribution occurs.
        uint256 accT42PerShare; // Accumulated T42s per share, times 1e12. See below.
        IParaTicket ticket; // if VIP pool, NFT ticket contract, else 0
        uint256 pooltype;
    }
    // every farm's percent of T42 issue
    uint8[10] public farmPercent;
    // The T42 TOKEN!
    ParaToken public t42;
    // Dev address.
    address public devaddr;
    // Treasury address
    address public treasury;
    // Fee Distritution contract address
    address public feeDistributor;
    // Mining income commission rate, default 5%
    uint256 public claimFeeRate;
    // Mining pool withdrawal fee rate, the default is 1.3%
    uint256 public withdrawFeeRate;
    // Block number when bonus T42 period ends.
    uint256 public bonusEndBlock;
    // Bonus muliplier for early t42 makers.
    uint256 public constant BONUS_MULTIPLIER = 1;
    // The migrator contract. It has a lot of power. Can only be set through governance (owner).
    IMigratorChef public migrator;
    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;
    // The block number when T42 mining starts.
    uint256 public startBlock;
    
    // the address of WETH
    address public WETH;
    // the address of Router
    IParaRouter02 public paraRouter;
    // Change returned after adding liquidity
    mapping(address => mapping(address => uint)) public userChange;
    // record who staked which NFT ticket into this contract
    mapping(address => mapping(address => uint[])) public ticket_stakes;
    // record total claimed T42 for per user & per PoolType
    mapping(address => mapping(uint256 => uint256)) public _totalClaimed;
    mapping(address => address) public _whitelist;
    // TOTAL Deposit pid => uint
    mapping(uint => uint) public poolsTotalDeposit;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );
    event WithdrawChange(
        address indexed user,
        address indexed token,
        uint256 change);
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(admin == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    constructor() public {
        admin = msg.sender;
    }
    
    function initialize(
        ParaToken _t42,
        address _treasury,
        address _feeDistributor,
        address _devaddr,
        uint256 _bonusEndBlock,
        address _WETH,
        IParaRouter02 _paraRouter
    ) external onlyOwner {
        t42 = _t42;
        treasury = _treasury;
        feeDistributor = _feeDistributor;
        devaddr = _devaddr;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _t42.startBlock();
        WETH = _WETH;
        paraRouter = _paraRouter;
        claimFeeRate = 500;
        withdrawFeeRate = 130;
    }
//the beginning of reentrancy bug:
    function depositSingle(uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
        depositSingleInternal(msg.sender, msg.sender, _pid, _token, _amount, paths, _minTokens);
    }

    //uint256 _minPoolTokens,
    function depositSingleTo(address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
        //Msg.sender is on the white list
        require(_whitelist[msg.sender] != address(0), "only white");
        
        IFeeDistributor(feeDistributor).setReferalByChef(_user, _whitelist[msg.sender]);
        depositSingleInternal(msg.sender, _user, _pid, _token, _amount, paths, _minTokens);
    }

    struct DepositVars{
        uint oldBalance;
        uint newBalance;
        uint amountA;
        uint amountB;
        uint liquidity;
    }

    //During the reentrancy process, the UBT contract deposits 222 genuine LP tokens, which are credited to ParaProxy’s ledger. 
    //After the reentrancy is completed, 222 LP tokens are added to the ParaProxy contract address, 
    //which the ParaProxy contract treats as LPs added by the attack contract and credits to the ledger. 
    function depositSingleInternal(address payer, address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) internal {
        require(paths.length == 2,"deposit: PE");
        //Stack too deep, try removing local variables
        DepositVars memory vars;
        (_token, _amount) = _doTransferIn(payer, _token, _amount);
        require(_amount > 0, "deposit: zero");
        //swap by path
        (address[2] memory tokens, uint[2] memory amounts) = depositSwapForTokens(_token, _amount, paths);
        //Go approve
        approveIfNeeded(tokens[0], address(paraRouter), amounts[0]);
        approveIfNeeded(tokens[1], address(paraRouter), amounts[1]);
        PoolInfo memory pool = poolInfo[_pid];
        //Non-VIP pool
        require(address(pool.ticket) == address(0), "T:E");
        //lp balance check
        vars.oldBalance = pool.lpToken.balanceOf(address(this));
        (vars.amountA, vars.amountB, vars.liquidity) = paraRouter.addLiquidity(tokens[0], tokens[1], amounts[0], amounts[1], 1, 1, address(this), block.timestamp + 600);
        vars.newBalance = pool.lpToken.balanceOf(address(this));
        //----------------- TODO 
        require(vars.newBalance > vars.oldBalance, "B:E");
        vars.liquidity = vars.newBalance.sub(vars.oldBalance);
        require(vars.liquidity >= _minTokens, "H:S");
        addChange(_user, tokens[0], amounts[0].sub(vars.amountA));
        addChange(_user, tokens[1], amounts[1].sub(vars.amountB));
        //_deposit
        _deposit(_pid, vars.liquidity, _user);
    }



    // Deposit LP tokens to MasterChef for T42 allocation.
    function depositInternal(uint256 _pid, uint256 _amount, address _user, address payer) internal {
        PoolInfo storage pool = poolInfo[_pid];
        pool.lpToken.safeTransferFrom(
            address(payer),
            address(this),
            _amount
        );
        if (address(pool.ticket) != address(0)) {
            UserInfo storage user = userInfo[_pid][_user];
            uint256 new_amount = user.amount.add(_amount);
            uint256 user_ticket_count = pool.ticket.tokensOfOwner(_user).length;
            uint256 staked_ticket_count = ticket_staked_count(_user, address(pool.ticket));
            uint256 ticket_level = pool.ticket.level();
            (, uint overflow) = check_vip_limit(ticket_level, user_ticket_count + staked_ticket_count, new_amount);
            require(overflow == 0, "Exceeding the ticket limit");
            deposit_all_tickets(pool.ticket);
        }
        _deposit(_pid, _amount, _user);
    }

    // Deposit LP tokens to MasterChef for para allocation.
    function _deposit(uint256 _pid, uint256 _amount, address _user) internal {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        //add total of pool before updatePool
        poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].add(_amount);
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending =
                user.amount.mul(pool.accT42PerShare).div(1e12).sub(
                    user.rewardDebt
                );
            //TODO
            _claim(pool.pooltype, pending);
        }
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
        emit Deposit(_user, _pid, _amount);
    }

    function withdraw_tickets(uint256 _pid, uint256 tokenId) public {
        //use memory for reduce gas
        PoolInfo memory pool = poolInfo[_pid];
        UserInfo memory user = userInfo[_pid][msg.sender];
        //use storage because of updating value
        uint256[] storage idlist = ticket_stakes[msg.sender][address(pool.ticket)];
        for (uint i; i< idlist.length; i++) {
            if (idlist[i] == tokenId) {
                (, uint overflow) = check_vip_limit(pool.ticket.level(), idlist.length - 1, user.amount);
                require(overflow == 0, "Please withdraw usdt in advance");
                pool.ticket.safeTransferFrom(address(this), msg.sender, tokenId);
                idlist[i] = idlist[idlist.length - 1];
                idlist.pop();
                return;
            }
        }
        require(false, "You never staked this ticket before");
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public {
        _withdrawInternal(_pid, _amount, msg.sender);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function _withdrawInternal(uint256 _pid, uint256 _amount, address _operator) internal{
        (address lpToken,uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, _operator);
        IERC20(lpToken).safeTransfer(_operator, actual_amount);
    }

    function _withdrawWithoutTransfer(uint256 _pid, uint256 _amount, address _operator) internal returns (address lpToken, uint actual_amount){
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_operator];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending =
            user.amount.mul(pool.accT42PerShare).div(1e12).sub(
                user.rewardDebt
            );
        _claim(pool.pooltype, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
        //sub total of pool
        poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].sub(_amount);
        lpToken = address(pool.lpToken);
        uint fee = _amount.mul(withdrawFeeRate).div(10000);
        IERC20(lpToken).approve(feeDistributor, fee);
        IFeeDistributor(feeDistributor).incomeWithdrawFee(_operator, lpToken, fee, _amount);
        actual_amount = _amount.sub(fee);
    }

    function withdrawSingle(address tokenOut, uint256 _pid, uint256 _amount, address[][2] memory paths) external{
        require(paths[0].length >= 2 && paths[1].length >= 2, "PE:2");
        require(paths[0][paths[0].length - 1] == tokenOut,"invalid path_");
        require(paths[1][paths[1].length - 1] == tokenOut,"invalid path_");
        //doWithraw Lp
        (address lpToken, uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, msg.sender);
        //remove liquidity
        address[2] memory tokens;
        uint[2] memory amounts;
        tokens[0] = IParaPair(lpToken).token0();
        tokens[1] = IParaPair(lpToken).token1();
        //Go approve
        approveIfNeeded(lpToken, address(paraRouter), actual_amount);
        (amounts[0], amounts[1]) = paraRouter.removeLiquidity(
            tokens[0], tokens[1], actual_amount, 0, 0, address(this), block.timestamp.add(600));
        //swap to tokenOut
        for (uint i = 0; i < 2; i++){
            address[] memory path = paths[i];
            require(path[0] == tokens[0] || path[0] == tokens[1], "invalid path_0");
            //Consider the same currency situation
            if(path[0] == tokens[0]){
                swapTokensOut(amounts[0], tokenOut, path);
            }else{
                swapTokensOut(amounts[1], tokenOut, path);    
            }
        }
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function approveIfNeeded(address _token, address spender, uint _amount) private{
        if (IERC20(_token).allowance(address(this), spender) < _amount) {
             IERC20(_token).approve(spender, _amount);
        }
    }

}