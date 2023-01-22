/**
 *Submitted for verification at Etherscan.io on 2020-10-07
*/

// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

contract Bank{


//reentrant here 
    function work(uint256 id, address goblin, uint256 loan, uint256 maxReturn, bytes calldata data)
        external payable
        onlyEOA accrue(msg.value)
    {
        // 1. Sanity check the input position, or add a new position of ID is 0.
        if (id == 0) {
            id = nextPositionID++;
            positions[id].goblin = goblin;
            positions[id].owner = msg.sender;
        } else {
            require(id < nextPositionID, "bad position id");
            require(positions[id].goblin == goblin, "bad position goblin");
            require(positions[id].owner == msg.sender, "not position owner");
        }
        emit Work(id, loan);
        // 2. Make sure the goblin can accept more debt and remove the existing debt.
        require(config.isGoblin(goblin), "not a goblin");
        require(loan == 0 || config.acceptDebt(goblin), "goblin not accept more debt");
        uint256 debt = _removeDebt(id).add(loan);
        // 3. Perform the actual work, using a new scope to avoid stack-too-deep errors.
        uint256 back;
        {
            uint256 sendETH = msg.value.add(loan);
            require(sendETH <= address(this).balance, "insufficient ETH in the bank");
            uint256 beforeETH = address(this).balance.sub(sendETH);
            Goblin(goblin).work.value(sendETH)(id, msg.sender, debt, data);
            back = address(this).balance.sub(beforeETH);
        }
        // 4. Check and update position debt.
        uint256 lessDebt = Math.min(debt, Math.min(back, maxReturn));
        debt = debt.sub(lessDebt);
        if (debt > 0) {
            require(debt >= config.minDebtSize(), "too small debt size");
            uint256 health = Goblin(goblin).health(id);
            uint256 workFactor = config.workFactor(goblin, debt);
            require(health.mul(workFactor) >= debt.mul(10000), "bad work factor");
            _addDebt(id, debt);
        }
        // 5. Return excess ETH back.
        if (back > lessDebt) SafeToken.safeTransferETH(msg.sender, back - lessDebt);
    }
}