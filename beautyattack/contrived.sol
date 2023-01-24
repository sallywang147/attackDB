/**
 *Submitted for verification at Etherscan.io on 2018-02-09
*/

pragma solidity ^0.4.16;

contract contrived{
  function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
    uint cnt = _receivers.length;

    //this is the buggy line: This overflow gave hackers a chance to withdraw more than the balance of an account. The hackers used a dynamic array of two addresses, and a value of 2²⁵⁵ to abuse the vulnerable contract and successfully transferred 2²⁵⁶ tokens to their accounts 
    uint256 amount = uint256(cnt) * _value;
    require(cnt > 0 && cnt <= 20);
    require(_value > 0 && balances[msg.sender] >= amount);

    balances[msg.sender] = balances[msg.sender].sub(amount);
    for (uint i = 0; i < cnt; i++) {
        balances[_receivers[i]] = balances[_receivers[i]].add(_value);
        Transfer(msg.sender, _receivers[i], _value);
    }
    return true;
  }
}