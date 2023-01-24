// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

contract contrived{

    function depositFromOtherContract(
        uint256 _depositAmount,
        uint8 _periodId,
        bool isUnlocked,
        address _from
    ) external {
        require(isPoolActive,'Contract is not running yet');
        _autoDeposit(_depositAmount,_periodId,isUnlocked,_from);

        _updateLevelPoolQualification(_from);
    }
}